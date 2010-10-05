%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(epps_master).

-behaviour(gen_server).

%% API
-export([start_link/0, execute/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	     terminate/2, code_change/3]).

-include("erlangapps.hrl").

-define(SERVER, ?MODULE). 

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, noargs, []).

execute(Cmd, Args, Cfg) ->
    gen_server:call(?SERVER, {Cmd, Args, Cfg}, infinity).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init(noargs) ->
    Server = case application:get_env(?APP, server) of
        undefined -> ?DEFAULT_SERVER;
        {ok, Server0} -> Server0
    end,
    ApiUrl = Server ++ ?API_PATH,
    {ok, #state{api_url=ApiUrl}}.

handle_call({Cmd, Args, Cfg}, From, State) ->
    Mod = list_to_atom("epps_op_" ++ Cmd),
    {Reply, NewState} = try Mod:do(Args, Cfg, From, State)
        catch _Pattern -> % TODO: catch function clause properly here
            ?PRINT("check ~p~n", [_Pattern]),
            ?PRINT("ohoh~n")
    end,
    {reply, Reply, NewState}.

handle_cast(not_supported, State) ->
    {noreply, State}.

handle_info(not_supported, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


