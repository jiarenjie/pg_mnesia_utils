%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_mchants).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  #{id => integer,
    mcht_full_name => binary,
    mcht_short_name => binary,
    payment_method =>
    fun(Value, O) ->
      case O of
        write ->
          [Payment_method] = Value,
          pg_mnesia_utils:do_out_2_model_one_field({Payment_method, atom}, O);
        save ->
          Payment_method = pg_mnesia_utils:do_out_2_model_one_field({Value, atom}, O),
          [Payment_method]
      end
    end
    ,
    quota =>
    fun(Value, O) ->
      case O of
        write ->
          [{txn, Txn}, {daily, Daily}, {monthly, Monthly}] = Value,
          Txn_binary = pg_mnesia_utils:do_out_2_model_one_field({Txn, integer}, O),
          Daily_binary = pg_mnesia_utils:do_out_2_model_one_field({Daily, integer}, O),
          Monthly_binary = pg_mnesia_utils:do_out_2_model_one_field({Monthly, integer}, O),
          <<Txn_binary/binary, "\,", Daily_binary/binary, "\,", Monthly_binary/binary>>;
        save ->
          [Txn, Daily, Monthly] = binary:split(Value, [<<"\,">>], [global]),
          Txn_integer = pg_mnesia_utils:do_out_2_model_one_field({Txn, integer}, O),
          Daily_integer = pg_mnesia_utils:do_out_2_model_one_field({Daily, integer}, O),
          Monthly_integer = pg_mnesia_utils:do_out_2_model_one_field({Monthly, integer}, O),
          [{txn, Txn_integer}, {daily, Daily_integer}, {monthly, Monthly_integer}]
      end
    end,
    status => atom,
    up_mcht_id => binary,
    up_term_no => binary,
    update_ts =>
    fun(Value, O) ->
      case O of
        write ->
          {Time1, Time2, Time3} = Value,
          Time1_binary = pg_mnesia_utils:do_out_2_model_one_field({Time1, integer}, O),
          Time2_binary = pg_mnesia_utils:do_out_2_model_one_field({Time2, integer}, O),
          Tim3_binary = pg_mnesia_utils:do_out_2_model_one_field({Time3, integer}, O),
          <<Time1_binary/binary, "\,", Time2_binary/binary, "\,", Tim3_binary/binary>>;
        save ->
          [Time1, Time2, Time3] = binary:split(Value, [<<"\,">>], [global]),
          Time1_integer = pg_mnesia_utils:do_out_2_model_one_field({Time1, integer}, O),
          Time2_integer = pg_mnesia_utils:do_out_2_model_one_field({Time2, integer}, O),
          Tim3_integer = pg_mnesia_utils:do_out_2_model_one_field({Time3, integer}, O),
          {Time1_integer, Time2_integer, Tim3_integer}
      end
    end
  }.

table_read_config() ->
  #{
    field_map => #{
      id => <<"id">>
      , mcht_full_name => <<"mcht_full_name">>
      , mcht_short_name => <<"mcht_short_name">>
      , status => <<"status">>
      , payment_method => <<"payment_method">>
      , up_mcht_id => <<"up_mcht_id">>
      , quota => <<"quota">>
      , up_term_no => <<"up_term_no">>
      , update_ts => <<"update_ts">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  mchants.