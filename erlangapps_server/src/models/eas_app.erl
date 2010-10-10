%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%% Data model for the user record.
%%% @end
%%% Created : 23 Sep 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_app).

%% API
-export([list/0, search/1]).

-include_lib("stdlib/include/qlc.hrl").
-include("erlangapps_server.hrl").

%%%===================================================================
%%% API
%%%===================================================================
list() ->
    eas_db:transaction(
        fun() ->
                Qh = qlc:q([A || A <- mnesia:table(app)]),
                qlc:e(Qh)
        end).

search(Pattern) ->
    eas_db:transaction(
        fun() ->
                Qh = qlc:q([A || #app{id=N}=A <- mnesia:table(app), 
                                 string:str(N, Pattern) > 0]),
                qlc:e(Qh)
        end).



