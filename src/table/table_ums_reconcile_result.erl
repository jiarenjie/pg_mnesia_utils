%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_ums_reconcile_result).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  #{
    id =>
    fun(Value, O) ->
      case O of
        write ->
          {Time1, Time2, Time3} = Value,
          Time1_binary = pg_mnesia_utils:do_out_2_model_one_field({Time1, binary}, O),
          Time2_binary = pg_mnesia_utils:do_out_2_model_one_field({Time2, binary}, O),
          Tim3_binary = pg_mnesia_utils:do_out_2_model_one_field({Time3, binary}, O),
          <<Time1_binary/binary, "\,", Time2_binary/binary, "\,", Tim3_binary/binary>>;
        save ->
          [Txn_date, Txn_time, Tys_trace_no] = binary:split(Value, [<<"\,">>], [global]),
          Txn_date_r = pg_mnesia_utils:do_out_2_model_one_field({Txn_date, binary}, O),
          Txn_time_r = pg_mnesia_utils:do_out_2_model_one_field({Txn_time, binary}, O),
          Tys_trace_no_r = pg_mnesia_utils:do_out_2_model_one_field({Tys_trace_no, binary}, O),
          {Txn_date_r, Txn_time_r, Tys_trace_no_r}
      end
    end
    , settlement_date => binary
    , txn_date => binary
    , txn_time => binary
    , ums_mcht_id =>
  fun
    (Value, O) when is_integer(Value) ->
      pg_mnesia_utils:do_out_2_model_one_field({Value, integer}, O);
    (Value, O) when is_binary(Value) ->
      case O of
        write ->
          pg_mnesia_utils:do_out_2_model_one_field({Value, binary}, O);
        save ->
          binary_to_integer(Value)
      end

  end
    , term_id => binary
    , bank_card_no => binary
    , txn_amt => integer
    , txn_type =>
  fun
    (Value, O) when is_atom(Value) ->
      pg_mnesia_utils:do_out_2_model_one_field({Value, atom}, O);
    (Value, O) when is_binary(Value) ->
      case O of
        write ->
          case Value of
            <<"E74">> ->
              <<"refund">>;
            _ ->
              <<"pay">>
          end;
        save ->
          binary_to_atom(Value, utf8)
      end

  end
    , txn_fee => integer
    , term_batch_no => binary
    , term_seq => binary
    , sys_trace_no => binary
    , ref_id => binary
    , auth_resp_code => binary
    , cooperate_fee => binary
    , cooperate_mcht_id => binary
    , up_txn_seq => binary
    , ums_order_id => binary
    , memo => binary
  }.

table_read_config() ->
  #{
    field_map => #{
      id => <<"id">>
      , settlement_date => <<"settlement_date">>
      , txn_date => <<"txn_date">>
      , txn_time => <<"txn_time">>
      , ums_mcht_id => <<"ums_mcht_id">>
      , term_id => <<"term_id">>

      , bank_card_no => <<"bank_card_no">>
      , txn_amt => <<"txn_amt">>
      , txn_type => <<"txn_type">>
      , txn_fee => <<"txn_fee">>
      , term_batch_no => <<"term_batch_no">>

      , term_seq => <<"term_seq">>
      , sys_trace_no => <<"sys_trace_no">>
      , ref_id => <<"ref_id">>
      , auth_resp_code => <<"auth_resp_code">>
      , cooperate_fee => <<"cooperate_fee">>

      , cooperate_mcht_id => <<"cooperate_mcht_id">>
      , up_txn_seq => <<"up_txn_seq">>
      , ums_order_id => <<"ums_order_id">>
      , memo => <<"memo">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  ums_reconcile_result.