%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_mcht_txn_acc).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  #{
    acc_index =>
    fun(Value, O) ->
      case O of
        write ->
          {Mcht_id, Txn_type, Month_date} = Value,
          Mcht_id_w = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, integer}, O),
          Txn_type_w = pg_mnesia_utils:do_out_2_model_one_field({Txn_type, atom}, O),
          Month_date_w = pg_mnesia_utils:do_out_2_model_one_field({Month_date, binary}, O),

          <<Mcht_id_w/binary, "\,", Txn_type_w/binary, "\,", Month_date_w/binary>>;
        save ->
          [Mcht_id, Txn_type, Month_date] = binary:split(Value, [<<"\,">>], [global]),
          Mcht_id_r = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, integer}, O),
          Txn_type_r = pg_mnesia_utils:do_out_2_model_one_field({Txn_type, atom}, O),
          Month_date_r = pg_mnesia_utils:do_out_2_model_one_field({Month_date, binary}, O),
          {Mcht_id_r, Txn_type_r, Month_date_r}
      end
    end,
    mcht_id => integer,
    txn_type => atom,
    month_date => binary,
    acc => integer
  }.

table_read_config() ->
  #{
    field_map => #{
      acc_index => <<"acc_index">>
      , mcht_id => <<"mcht_id">>
      , txn_type => <<"txn_type">>
      , month_date => <<"month_date">>
      , acc => <<"acc">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  mcht_txn_acc.