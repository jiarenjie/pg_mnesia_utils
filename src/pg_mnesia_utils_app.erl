%%%-------------------------------------------------------------------
%% @doc pg_mnesia_utils public API
%% @end
%%%-------------------------------------------------------------------

-module(pg_mnesia_utils_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    pg_mnesia_utils_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
