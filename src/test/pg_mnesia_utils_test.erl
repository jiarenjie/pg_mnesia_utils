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
          fun test_1/0
        ]
    }

  }
.




start() ->
  lager:start(),
  application:set_env(mnesia, dir, "/tmp/mnesia_test"),
  db_init(),
  pg_mnesia_utils:start_link().


cleanup(Pid) ->
  ok.

test_1() ->
  ok = pg_mnesia_utils:restore(table_mchants,"tests/mchants.txt"),
  ok = pg_mnesia_utils:backup(table_mchants,"tests/mchants2.txt"),
  {ok,BdBackup} = file:read_file("tests/mchants.txt"),
  {ok,BdBackup2} = file:read_file("tests/mchants2.txt"),
  ?assertEqual(BdBackup,BdBackup2),
  ok.


db_init() ->
  mnesia:stop(),
  mnesia:delete_schema([node()]),
  mnesia:create_schema([node()]),
  ok = mnesia:start(),
  {atomic, ok} = mnesia:create_table(
    mchants,
    [   %%{index,[order_id]}

      {attributes, record_info(fields, mchants)}
      %, {index, [mcht_index_key]}
      , {disc_copies, [node()]}
    ]).