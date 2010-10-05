%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%% Erlangapps database interface which provides all data access functions.
%%% @end
%%% Created :  12 Aug 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_db).

-export([setup/0, transaction/1]).

-include_lib("stdlib/include/qlc.hrl").
-include("erlangapps_server.hrl").

%%%===================================================================
%%% API functions 
%%%===================================================================
setup() ->
    case mnesia:create_schema([node()]) of
	    ok -> start_mnesia();
	    {error, {_, {already_exists, _}}} -> start_mnesia();
	    {error, _} = E -> E
	end.

transaction(Fun) ->
    mnesia:activity(transaction, Fun).

%%%===================================================================
%%% internal functions 
%%%===================================================================

start_mnesia() ->
    case mnesia:start() of
    	{error, _} = E -> E;
    	ok -> ensure_tables(?TABLES)
    end.

ensure_tables([]) -> ok;
ensure_tables([{Name, Def} | Rest]) ->
    case mnesia:create_table(Name, Def) of
	    {atomic, ok} -> ensure_tables(Rest);
	    {aborted, {already_exists, Name}} -> ensure_tables(Rest);
	    {aborted, Reason} -> {error, Reason}
    end.


