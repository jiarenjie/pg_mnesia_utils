%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_history_mcht_txn_log).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  table_mcht_txn_log:table_deal_config().

table_read_config() ->
  table_mcht_txn_log:table_read_config().

table_name() ->
  history_mcht_txn_log.