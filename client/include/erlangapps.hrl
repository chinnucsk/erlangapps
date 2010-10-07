%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% Created : 31 Jul 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-define(APP, erlangapps).

-define(COMMANDS, ["install", "uninstall", "update", "list", "search", "publish"]).

-define(PRINT(Msg, Args), io:format(Msg, Args)).
-define(PRINT(Msg), ?PRINT(Msg, [])).

-define(DEFAULT_LIB_DIR, "/usr/local/lib/erlangapps").
-define(DEFAULT_SERVER, "http://apps.erlangapps.org:5929").
-define(API_PATH, "/api").
-define(LOCAL_SETTINGS_FILE, filename:join([os:getenv("HOME"), ".erlangapps"])).
-define(API_TOKEN_FILE, filename:join([os:getenv("HOME"), ".erlangapps_token"])).

-define(PUBLISH_URL, "http://127.0.0.1:7777/api/app").

-record(state, {api_url}).
