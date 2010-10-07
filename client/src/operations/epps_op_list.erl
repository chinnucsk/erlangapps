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
    LibPath = epps_utils:get_config(lib_dir), 
    Apps = lists:foldl(
        fun(Path, Acc) ->
            case lists:prefix(LibPath, Path) of
                true ->
                    [AppFile] = filelib:wildcard(filename:join([Path, "*.app"])),
                    {ok, [{application, Name, Cfg}]} = file:consult(AppFile),
                    Vsn = proplists:get_value(vsn, Cfg),
                    [{Name, Vsn} | Acc];
                false -> Acc
            end 
        end,
        [],
        code:get_path()),
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

