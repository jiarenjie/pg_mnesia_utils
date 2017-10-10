%%%-------------------------------------------------------------------
%% @doc pg_mnesia_utils top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(pg_mnesia_utils_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    RestartStrategy = {one_for_one, 4, 60},
    Children = [{pg_mnesia_utils,
        {pg_mnesia_utils, start_link, []},
        permanent, 2000, supervisor, [pg_mnesia_utils]}],
    {ok, {RestartStrategy, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
