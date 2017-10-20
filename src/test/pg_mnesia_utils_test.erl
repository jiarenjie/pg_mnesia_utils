%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十月 2017 11:10
%%%-------------------------------------------------------------------
-module(pg_mnesia_utils_test).
-include_lib("eunit/include/eunit.hrl").
-author("jiarj").

-record(mchants, {
  id = 0
  , mcht_full_name = <<"">>
  , mcht_short_name = <<"">>
  , status = normal
  , payment_method = [gw_netbank]
  , up_mcht_id = <<"">>
  , quota = [{txn, -1}, {daily, -1}, {monthly, -1}]
  , up_term_no = <<"12345678">>
  , update_ts = erlang:timestamp()
}).
-record(users, {
  id,
  name,
  email,
  password,
  role,
  status,
  last_update_ts = erlang:timestamp(),
  last_login_ts
}).
-record(ums_reconcile_result, {
  id
  , settlement_date
  , txn_date
  , txn_time
  , ums_mcht_id
  , term_id
  , bank_card_no
  , txn_amt
  , txn_type
  , txn_fee
  , term_batch_no
  , term_seq
  , sys_trace_no
  , ref_id
  , auth_resp_code
  , cooperate_fee
  , cooperate_mcht_id
  , up_txn_seq
  , ums_order_id
  , memo

}).


%% API
-export([]).

-compile(export_all).

my_test_() ->
  {
    setup
    , fun start/0
    , fun cleanup/1
    ,
    {
      inorder,
      [
        fun test_start/0
        , fun test_0/0
        , fun test_1/0
        , fun test_2/0
        , fun test_3/0
        , fun test_4/0

      ]
    }

  }
.




start() ->
  lager:start(),
  application:set_env(mnesia, dir, "/tmp/mnesia_test"),
  db_init(),
  pg_mnesia_utils_sup:start_link().


cleanup(Pid) ->
  ok.

test_start() ->
  {Error, {Already_started, _}} = pg_mnesia_utils_sup:start_link(),
  ?assertEqual({Error, Already_started}, {error, already_started}).
test_0() ->
  ok = pg_mnesia_utils:backup(table_mchants, "tests/mchants_empty.txt"),
  ok = timer:sleep(1000),
  ok = pg_mnesia_utils:restore(table_mchants, "tests/mchants_empty.txt"),
  {ok, BdBackup} = file:read_file("tests/mchants_empty.txt"),
  File_head = <<"id^^mcht_full_name^^mcht_short_name^^status^^payment_method^^up_mcht_id^^quota^^up_term_no^^update_ts$\n">>,
  ?assertEqual(BdBackup, File_head),
  ok = pg_mnesia_utils:restore(table_mchants, "tests/mchants_empty.txt"),
  ok.
test_1() ->
  ok = pg_mnesia_utils:restore(table_mchants, "tests/not_exis"),
  ok.
test_2() ->
  ok = pg_mnesia_utils:restore(table_users, "tests/table_users.txt"),
  ok = timer:sleep(1000),
  ok = pg_mnesia_utils:backup(table_users, "tests/table_users2.txt"),
  ok = timer:sleep(1000),
  {ok, BdBackup} = file:read_file("tests/table_users.txt"),
  {ok, BdBackup2} = file:read_file("tests/table_users2.txt"),
  ?assertEqual(BdBackup, BdBackup2),
  ok.
test_3() ->
  ok = pg_mnesia_utils:restore(table_mchants, "tests/mchants.txt"),
  ok = timer:sleep(1000),
  ok = pg_mnesia_utils:backup(table_mchants, "tests/mchants2.txt"),
  ok = timer:sleep(1000),
  {ok, BdBackup} = file:read_file("tests/mchants.txt"),
  {ok, BdBackup2} = file:read_file("tests/mchants2.txt"),
  ?assertEqual(BdBackup, BdBackup2),
  ok.
test_4() ->
  ok = pg_mnesia_utils:restore(table_ums_reconcile_result, "tests/table_ums_reconcile_result.txt"),
  ok = pg_mnesia_utils:backup(table_ums_reconcile_result, "tests/table_ums_reconcile_result2.txt"),
  ok.








db_init() ->
  mnesia:stop(),
  mnesia:delete_schema([node()]),
  mnesia:create_schema([node()]),
  ok = mnesia:start(),
  [creat_table(X) || X <- [mchants, users, ums_reconcile_result]].

creat_table(mchants) ->
  {atomic, ok} = mnesia:create_table(
    mchants,
    [   %%{index,[order_id]}

      {attributes, record_info(fields, mchants)}
      %, {index, [mcht_index_key]}
      , {disc_copies, [node()]}
    ]);
creat_table(users) ->
  {atomic, ok} = mnesia:create_table(
    users,
    [   %%{index,[order_id]}

      {attributes, record_info(fields, users)}
      %, {index, [mcht_index_key]}
      , {disc_copies, [node()]}
    ]);
creat_table(ums_reconcile_result) ->
  {atomic, ok} = mnesia:create_table(
    ums_reconcile_result,
    [   %%{index,[order_id]}

      {attributes, record_info(fields, ums_reconcile_result)}
      %, {index, [mcht_index_key]}
      , {disc_copies, [node()]}
    ]).
