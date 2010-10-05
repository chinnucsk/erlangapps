%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%% Data model for the user record.
%%% @end
%%% Created : 25 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_user).

%% API
-export([create/2, check/1, check/2]).

-include_lib("stdlib/include/qlc.hrl").
-include("erlangapps_server.hrl").

%%%===================================================================
%%% API
%%%===================================================================
create(Name, Password) ->
    Now = calendar:now_to_universal_time(now()),
    Token = crypto:rand_uniform(1000000, 9999999), % TODO: create proper token
    % TODO: salt and hash password
    User = #user{username=Name, password=Password, registered_at=Now, 
                 updated_at=Now, api_token=Token},
    eas_db:transaction(
        fun() ->
                % TODO: check whether user exists and return proper values
                mnesia:write(User)
        end).

check(Token) ->
    eas_db:transaction(
        fun() ->
                Q = qlc:q([User || User <- mnesia:table(user),
                        User#user.api_token == Token]),
                case qlc:e(Q) of
                    [] -> undefined;
                    [User] -> User
                end
        end).
 
check(Username, Password) ->
    eas_db:transaction(
        fun() ->
                Q = qlc:q([User || User <- mnesia:table(user),
                        User#user.username == Username,
                        User#user.password == Password]),
                case qlc:e(Q) of
                    [] -> undefined;
                    [User] -> User
                end
        end).
    
