%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 10:26
%%%-------------------------------------------------------------------
-module(pg_mnesia_utils).
-author("jiarj").
-behaviour(gen_server).
-compile(export_all).
-include_lib("stdlib/include/qlc.hrl").
-include("include/tableConfig.hrl").
%% API
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->

  {ok, #state{}}.

backup(TableName, FileName) ->
  gen_server:cast(?SERVER, {backup, TableName, FileName}).
restore(M, FileName) ->
  case filelib:is_regular(FileName) of
    true -> gen_server:cast(?SERVER, {restore, M, FileName});
    _ -> lager:error(["file : ~p is not exis!!!", [FileName]]),
      ok
  end.

handle_call(_Request, _From, State) ->
  {noreply, State}.

handle_cast({backup, TableName, FileName}, #state{} = State) ->

  Qh = mnesia:table(TableName),
  Fields = mnesia:table_info(TableName, attributes),
  Config = table_deal_config(TableName),
  Table_read_config = table_read_config(TableName),
  Delimit_field = maps:get(delimit_field, Table_read_config),
  Delimit_line = maps:get(delimit_line, Table_read_config),
  file:write_file(FileName, [], [write]),
  LinesGap = 500,
  lager:info("backup table: ~p from file : ~ts start", [TableName, FileName]),

  F = fun
        (Repo, {N, Acc, Total}) when N >= LinesGap ->
          %% reach write threshold
          %% dump this to file
          lager:debug("Write ~p lines to file:~ts", [Total, FileName]),
          csv_parser:write_to_file(FileName, Acc, Fields, Delimit_field, Delimit_line, [append]),
          %% initial new empty acc
          {1, [repo_to_mode(Repo,Fields, Config, write)], Total + N};
        (Repo, {N, Acc, Total}) ->
          {N + 1, [repo_to_mode(Repo,Fields, Config, write) | Acc], Total}
      end,
  F1 = fun() ->
    qlc:fold(F, {0, [], 0}, Qh)
       end,
  {atomic, {N, Rest, SubTotal}} = mnesia:transaction(F1),
  lager:debug("Write ~p lines to file:~ts", [SubTotal + N, FileName]),
  csv_parser:write_to_file(FileName, Rest, Fields, Delimit_field, Delimit_line, [append]),
  lager:info("Write table: ~p to file : ~ts success,total: ~p", [TableName, FileName, SubTotal + N]),
  {N, Rest, SubTotal},
  {noreply, State};
handle_cast({restore, TableName, FileName},#state{} = State) ->
  Config = table_read_config(TableName),
  Fields = mnesia:table_info(TableName, attributes),
  lager:info("restore table: ~p to file :~ts start", [TableName, FileName]),
  F = fun(Bin) ->
    Lists = csv_parser:parse(Config, Bin),
    Config2 = csv_table_deal:table_deal_config(TableName),
    F2 = fun(Repo, Acc) ->
      Mode = to_mode(Repo, Fields, Config2, save),
%%      lager:debug("Mode:~p",[Mode]),

      save(TableName,Mode,Fields)
%%      behaviour_repo:save(M, maps:from_list(Mode), [dirty])
         end,
    lists:foldl(F2, [], Lists)
      end,
%%  FileName = "/mnt/d/csv/"++atom_to_list(M)++".txt",
  Total = csv_parser:read_line_fold(F, FileName, 500),
  lager:info("restore table: ~p to file : ~ts success,total: ~p", [TableName, FileName, Total]),
  {noreply, State};
handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

repo_to_mode(Repo,Fields, Config, Operate) ->
  Map = repo_to_map(Repo,Fields),
  to_mode(Map,Fields,Config,Operate).

repo_to_map(Repo, Fields) ->
  ValueList = tl(tuple_to_list(Repo)),
%%  lager:info("Fields = ~p,ValueList = ~p", [Fields, ValueList]),
  List = lists:zip(Fields, ValueList),
  maps:from_list(List).

%%================================================================================================

to_mode(X, Fields, Config, Operate) ->
  F = fun out_2_model_one_field/2,
  {VL, _, _, _} = lists:foldl(F, {[], Config, X, Operate}, Fields),
  VL
.
out_2_model_one_field(Field, {Acc, Model2OutMap, PL, Operate}) when is_atom(Field), is_list(Acc), is_map(Model2OutMap) ->
  Config = maps:get(Field, Model2OutMap),

%%  lager:debug("Config=~p,Field=~p", [Config, Field]),

  Value = do_out_2_model_one_field({maps:get(Field, PL), Config}, Operate),
  %% omit undefined key/value , which means not appear in PL

  AccNew = [{Field, Value} | Acc],
  {AccNew, Model2OutMap, PL, Operate}.

do_out_2_model_one_field({undefined, _}, write) ->
  <<"undefined">>;
do_out_2_model_one_field({<<"undefined">>, _}, save) ->
  undefined;
do_out_2_model_one_field({Value, binary}, write) ->
  Value;
do_out_2_model_one_field({Value, binary}, save) ->
  Value;

do_out_2_model_one_field({Value, integer}, write) ->
  integer_to_binary(Value);
do_out_2_model_one_field({Value, integer}, save) ->
  binary_to_integer(Value);

do_out_2_model_one_field({Value, atom}, write) ->
  atom_to_binary(Value, utf8);
do_out_2_model_one_field({Value, atom}, save) ->
  binary_to_atom(Value, utf8);

do_out_2_model_one_field({Value, ts}, write) ->
  {Time1, Time2, Time3} = Value,
  Txn_binary = pg_mnesia_utils:do_out_2_model_one_field({Time1, integer}, write),
  Daily_binary = pg_mnesia_utils:do_out_2_model_one_field({Time2, integer}, write),
  Monthly_binary = pg_mnesia_utils:do_out_2_model_one_field({Time3, integer}, write),
  <<Txn_binary/binary, "\,", Daily_binary/binary, "\,", Monthly_binary/binary>>;
do_out_2_model_one_field({Value, ts}, save) ->
  [Time1, Time2, Time3] = binary:split(Value, [<<"\,">>], [global]),
  Time1_integer = pg_mnesia_utils:do_out_2_model_one_field({Time1, integer}, save),
  Time2_integer = pg_mnesia_utils:do_out_2_model_one_field({Time2, integer}, save),
  Tim3_integer = pg_mnesia_utils:do_out_2_model_one_field({Time3, integer}, save),
  {Time1_integer, Time2_integer, Tim3_integer};

do_out_2_model_one_field({Value, F}, write) when is_function(F) ->
  F(Value, write);
do_out_2_model_one_field({Value, F}, save) when is_function(F) ->
  F(Value, save).
%%================================================================================================

save(TableName,Mode, Fields) ->
  %% 将map 转换为 能保存的 touple
  Repo = erlang:list_to_tuple([TableName | maps:values(Mode)]),
  ok = mnesia:dirty_write(TableName,Repo)
  .