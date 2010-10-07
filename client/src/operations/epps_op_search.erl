%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created : 7 Oct 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(epps_op_search).

%% API
-export([do/4]).

-include("erlangapps.hrl").

-define(URL(Api), Api ++ "/search").

%%%===================================================================
%%% API
%%%===================================================================
do([], _Cfg, _From, State) -> 
    usage(),
    {ok, State};
do([Pattern | _], _Cfg, _From, State) ->
    Response = epps_utils:request(?URL(State#state.api_url), 
        [{"pattern", Pattern}]),
    Apps = Response, % FIXME: convert response properly
    ?PRINT("~n -- Matching Applications -- ~n~n"),
    [?PRINT("~p (~s)~n", [Name, Vsn]) || {Name, Vsn} <- Apps],
    ?PRINT("~n"),
    {ok, State}.
    
%%%===================================================================
%%% Internal functions 
%%%===================================================================
usage() ->
    ?PRINT("name required").
