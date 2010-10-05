%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_tcp_session).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-include("erlangapps_server.hrl").

-define(SERVER, ?MODULE). 

-record(state, {socket, request, response, user}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Sock) ->
    gen_server:start_link(?MODULE, Sock, []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init(Sock) ->
    erlang:display(started),
    inet:setopts(Sock, [{active, once}]),
    {ok, #state{socket=Sock}}.

handle_call(not_supported, _From, State) ->
    {noreply, State}.

handle_cast(not_supported, State) ->
    {noreply, State}.

handle_info({tcp_closed, Sock}, State) when Sock == State#state.socket ->
    {stop, normal, State};
handle_info({tcp, Sock, Data}, State) when Sock == State#state.socket ->
    erlang:display({received, Data}),
    {request, Request} = binary_to_term(Data),
    NewState = process(Request, State), 
    inet:setopts(Sock, [{active, once}]),
    {noreply, NewState}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
process({auth, _}, #state{socket=Sock, request=undefined}=State) ->
    reply(invalid_request, Sock),
    State;
process({auth, AuthDetails}, #state{socket=Sock, request=Request}=State) ->
    NewState = case eas_user:check(AuthDetails) of
        undefined ->
            reply({error, invalid_auth_details}, Sock),
            State;
        User ->
            State2 = process_auth(Request, State#state{user=User}),
            reply({ok, User#user.api_token, State2#state.response}, Sock),
            State2#state{request=undefined, user=undefined, response=undefined}
    end,
    NewState;
process({auth, AuthDetails, Request}, #state{socket=Sock}=State) ->
    NewState = case eas_user:check(AuthDetails) of
        undefined ->
            reply({error, invalid_auth_details}, Sock),
            State#state{request=Request};
        User ->
            State2 = process_auth(Request, State#state{user=User}),
            reply({ok, User#user.api_token, State2#state.response}, Sock),
            State2#state{response=undefined, user=undefined}
    end,
    NewState;
process(list, #state{socket=Sock}=State) ->
    Apps = eas_db:all_app_versions(),
    reply(Apps, Sock),
    State.

process_auth({publish, _Zip}, State) ->
    _App = todo, % TODO unzip,
    % TODO do processing
    State#state{response=ok}.

reply(Data, Sock) ->
    Reply = term_to_binary({reply, Data}),
    ok = gen_tcp:send(Sock, Reply).
