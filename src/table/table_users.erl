%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_users).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  #{
    id => integer,
    name => binary,
    email => binary,
    password => binary,
    role => atom,
    status => atom,
    last_update_ts => ts,
    last_login_ts => ts
  }.

table_read_config() ->
  #{
    field_map => #{
      id => <<"id">>
      , name => <<"name">>
      , email => <<"email">>
      , password => <<"password">>
      , role => <<"role">>
      , status => <<"status">>
      , last_update_ts => <<"last_update_ts">>
      , last_login_ts => <<"last_login_ts">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  users.