%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_history_ums_reconcile_result).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  table_ums_reconcile_result:table_deal_config().

table_read_config() ->
  table_ums_reconcile_result:table_read_config().

table_name() ->
  ums_reconcile_result.