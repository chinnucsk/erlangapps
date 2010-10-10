%%%-------------------------------------------------------------------
%%% @author Tino Breddin <tino.breddin@erlang-solutions.com>
%%% @copyright (C) 2010, Tino Breddin
%%% @doc
%%%
%%% @end
%%% Created :  3 Sep 2010 by Tino Breddin <tino.breddin@erlang-solutions.com>
%%%-------------------------------------------------------------------
-module(eas_app_resource).

-export([init/1, allowed_methods/2, content_types_provided/2, 
         to_json/2, is_authorized/2, process_post/2]).

-include_lib("webmachine/include/webmachine.hrl").

-record(context, {user}).

init(_Args) ->
    {ok, #context{}}.

allowed_methods(Req, Context) ->
    {['HEAD', 'GET', 'POST', 'PUT'], Req, Context}.

content_types_provided(Req, Context) ->
    {[{"text/javascript", to_json}], Req, Context}.

is_authorized(Req, Context) ->
    case wrq:method(Req) of
        'POST' -> 
            User = case wrq:get_req_header("authorization", Req) of
                "Basic " ++ Base64 ->
                    Str = base64:mime_decode_to_string(Base64),
                    case string:tokens(Str, ":") of
                        [Username, Password] ->
                            eas_user:check(Username, Password);
                        _ -> []
                    end;
                Token -> eas_user:check(Token)
            end,
            case User of
                undefined -> {"Basic realm=ErlangApps", Req, Context};
                _ -> {true, Req, Context#context{user=User}}
            end;
        _ -> {true, Req, Context}
    end.

to_json(Req, Context) ->
    Path = wrq:disp_path(Req),
    Response = case Path of 
        "list" -> eas_app:list();
        "search" -> search(Req);
        _ -> not_known
    end,
    {mochijson2:encode(Response), Req, Context}.

process_post(Req, Context) ->
    _Zip = wrq:req_body(Req),
    {true, Req, Context}. 

search(Req) ->
    case wrq:get_qs_value("pattern", Req) of
        undefined -> {error, {missing_parameter, pattern}};
        Pattern -> eas_app:search(Pattern)
    end.
