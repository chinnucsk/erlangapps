%%%-------------------------------------------------------------------
%%% @author Tino Breddin <dev.can.i@gmail.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%% Main header file for the erlangapps_server application.
%%% @end
%%% Created :  12 Aug 2010 by Tino Breddin <dev.can.i@gmail.com>
%%%-------------------------------------------------------------------

-record(app, {id, description, version}).

-record(app_dependency, {app, depends_on}).

-record(user, {username, password, api_token, registered_at, updated_at}).

-define(APP, erlangapps_server).

-define(TABLES,
    [
        {app, [{attributes, record_info(fields, app)},
                {disc_copies, [node()]},
                {record_name, app}]},
        {app_dependency, [{attributes, record_info(fields, app_dependency)},
                {disc_copies, [node()]},
                {record_name, app_dependency}]},
        {user, [{attributes, record_info(fields, user)},
                {disc_copies, [node()]},
                {record_name, user}]}
    ]).
