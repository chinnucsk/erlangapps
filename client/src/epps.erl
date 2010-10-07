%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(epps).

-export([main/1]).

-include("erlangapps.hrl").

%%%===================================================================
%%% API functions
%%%===================================================================
main([]) -> usage();
main([Cmd | Args0]) ->
    % don't log standard events
    error_logger:tty(false),
    load_local_config(),
    {Args, Cfg} = get_configuration(Args0),
    erlang:display({cmd, Cmd, args, Args, cfg, Cfg}),
    execute(Cmd, Args, Cfg).

%%%===================================================================
%%% Internal functions
%%%===================================================================
execute("help", _, _) -> usage(0);

execute(Cmd, Args, Cfg) ->
	ok = application:start(erlangapps),
    try epps_master:execute(Cmd, Args, Cfg) catch 
        exit:{{undef, [{_, do, _}|_]}, _} -> usage()
    end,
	application:stop(erlangapps).

get_configuration(Args) -> get_configuration(Args, {[], []}).
get_configuration([], Res) -> Res;
get_configuration([Arg | Args0], {ResA, ResC}) ->
    {Res, Args} = case {string:str(Arg, "---"), string:str(Arg, "--"), string:chr(Arg, $-)} of
        {1, _, _} -> usage();
		{_, 1, _} ->
		    ArgName = string:strip(Arg, left, $-),
			{{ResA , ResC ++ [ArgName]}, Args0};
		{_, _, 1} ->
	    	ArgName = string:strip(Arg, left, $-),
			[ArgValue | Rest] = Args0,
			{{ResA, ResC ++ [{ArgName, ArgValue}]}, Rest};
		{_, _, _} ->
			{{ResA ++ [Arg], ResC}, Args0}
	end,
    get_configuration(Args, Res).
		  
load_local_config() ->
    {ok, Settings} = case file:consult(?LOCAL_SETTINGS_FILE) of
        {error, _} -> {ok, []};
        {ok, _} = R -> R
    end,
    [application:set_env(?APP, Key, Val) || {Key, Val} <- Settings].

usage() -> usage(1).
usage(C) ->
    Message = 
    "~n"
    "  ErlangApps is a OTP-conformant package manager for Erlang.~n"
    "  Follow the pointers in this overview for more information.~n"
    "~n"
    "    Usage:~n"
    "      epps -h/--help~n"
    "      epps -v/--version~n"
    "      epps command [arguments...] [options...]~n"
    "~n"
    "    Examples:~n"
    "      epps list --remote~n"
    "~n"
    "    Further information:~n"
    "      http://erlangapps.org~n"
    "",
    io:format(Message, []),
    case C of
	    0 -> ok;
	    _ -> halt(C)
    end.

