%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%% This module implements the application callback functions for erlangapps-server.
%%% @end
%%% Created :  8 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(erlangapps_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================
start(_StartType, _StartArgs) ->
    ok = eas_db:setup(),
    eas_sup:start_link().

stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
