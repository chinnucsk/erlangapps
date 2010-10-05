%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_tcp_master).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-define(PORT, 5929).
-define(LISTEN_OPTIONS, [binary, {active, false}, {backlog, 30}, {packet, 2},
                         {reuseaddr, true}]).
-define(ACCEPTORS, 5).

-record(state, {socket}).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, Sock} = gen_tcp:listen(?PORT, ?LISTEN_OPTIONS),
    ok = start_acceptors(?ACCEPTORS, Sock),
    {ok, #state{socket=Sock}}.

handle_call(not_supported, _From, State) ->
    {noreply, State}.

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

start_acceptors(0, _) -> ok;
start_acceptors(N, Sock) ->
    {ok, _} = eas_tcp_acceptor_sup:start_acceptor(Sock),
    start_acceptors(N-1, Sock).

