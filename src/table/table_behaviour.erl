%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:06
%%%-------------------------------------------------------------------
-module(table_behaviour).
-author("jiarj").

%% API
-export([]).
-compile(export_all).

-callback table_deal_config()->
  Map :: map().

-callback table_read_config()->
  Map :: map().

-callback table_name()->
  TableName :: atom().


get_table_name(M)->
  M:table_name().

get_table_deal_config(M)->
  M:table_deal_config().

get_table_read_config(M)->
  M:table_read_config().
