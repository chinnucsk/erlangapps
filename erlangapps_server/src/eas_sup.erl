%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-include("erlangapps_server.hrl").

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================
init([]) ->
    RestartStrategy = rest_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    {ok, Ip} = application:get_env(?APP, api_ip),
    {ok, Port} = application:get_env(?APP, api_port),
    {ok, Backlog} = application:get_env(?APP, api_backlog),
    {ok, Log} = application:get_env(?APP, api_log_dir),
    {ok, DispatchFile} = application:get_env(?APP, api_dispatch_file),
    {ok, Dispatch} = file:consult(DispatchFile),

    ApiConfig = [{ip, Ip}, {backlog, Backlog}, {port, Port}, {log_dir, Log},
		         {dispatch, Dispatch}],

    Api = {webmachine_mochiweb, {webmachine_mochiweb, start, [ApiConfig]},
	       permanent, 1000, worker, dynamic},

    {ok, {SupFlags, [Api]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
