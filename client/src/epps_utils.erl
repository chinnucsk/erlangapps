%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created : 25 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(epps_utils).

%% API
-export([request/1, request/2, get_config/1, get_credentials/0]).

-include("erlangapps.hrl").

%%%===================================================================
%%% API
%%%===================================================================
request(Url) -> request(Url, []).
request(Url0, Params) ->
    ParamString = string:join([K++"="++V || {K, V} <- Params], "&"),
    Url = Url0 ++ "?" ++ ParamString,
    {ok, {_, _, Body}} = httpc:request(Url),
    Body.

get_config(Key) ->
    case application:get_env(?APP, Key) of
        {ok, Val} -> Val;
        undefined ->
            case Key of
                lib_dir -> ?DEFAULT_LIB_DIR;
                server -> ?DEFAULT_SERVER
            end
    end.

get_credentials() ->
    ?PRINT("Please provide your authentication details~n"),
    [Username] = string:tokens(io:get_line("Username: "), "\n"),
    %?PRINT("Password: "),
    %Password = io:get_password(),
    %?PRINT("~n"),
    % FIXME: can't use above method because escript still uses the old shell
    [Password] = string:tokens(io:get_line("Password: "), "\n"),
    % TODO: hash the password
    {Username, Password}.

