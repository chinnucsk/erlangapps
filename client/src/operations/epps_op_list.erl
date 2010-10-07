%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created : 23 Sep 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(epps_op_list).

%% API
-export([do/4]).

-include("erlangapps.hrl").

-define(URL(Api), Api ++ "/list").

%%%===================================================================
%%% API
%%%===================================================================
do(_Args, Cfg, _From, State) ->
    case lists:member("remote", Cfg) of
	    false -> local(State);
	    true  -> remote(State)
    end.

%%%===================================================================
%%% Internal functions 
%%%===================================================================
local(State) ->
    Apps = lists:map(
	     fun(A) ->
		     {ok, [{application, Name, Cfg}]} = file:consult(A),
		     Vsn = proplists:get_value(vsn, Cfg),
		     {Name, Vsn}
	     end,
         filelib:wildcard(epps_utils:get_config(lib_dir) ++ "/*/ebin/*.app")),
    ?PRINT("~n -- Locally Installed Applications -- ~n~n"),
    [?PRINT("~p (~s)~n", [Name, Vsn]) || {Name, Vsn} <- Apps],
    ?PRINT("~n"),
    {ok, State}.
		     
remote(#state{api_url=ApiUrl}=State) ->
    Apps = epps_utils:request(?URL(ApiUrl)),
    ?PRINT("~n -- Available Applications -- ~n~n"),
    [?PRINT("~p (~s)~n", [Name, Vsn]) || {Name, Vsn} <- Apps],
    ?PRINT("~n"),
    {ok, State}.

