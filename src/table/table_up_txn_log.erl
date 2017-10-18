%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_up_txn_log).
-author("jiarj").
-behaviour(table_behaviour).

%% API
-export([table_deal_config/0, table_read_config/0, table_name/0]).


table_deal_config() ->
  #{mcht_index_key =>
  fun(Value, O) ->
    case O of
      write ->
        {Mcht_id, Mcht_txn_date, Mcht_txn_seq} = Value,
        B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
        B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
        B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
        <<B_Mcht_id/binary, "\,", B_Mcht_txn_date/binary, "\,", B_Mcht_txn_seq/binary>>;
      save ->
        [Mcht_id, Mcht_txn_date, Mcht_txn_seq] = binary:split(Value, [<<"\,">>], [global]),
        B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
        B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
        B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
        {B_Mcht_id, B_Mcht_txn_date, B_Mcht_txn_seq}
    end
  end,
    txn_type => atom,

    up_merId => binary,
    up_txnTime => binary,
    up_orderId => binary,
    up_txnAmt => integer,
    up_reqReserved => binary,
    up_orderDesc => binary,
    up_issInsCode => binary,
    up_index_key =>
    fun(Value, O) ->
      case O of
        write ->
          {Mcht_id, Mcht_txn_date, Mcht_txn_seq} = Value,
          B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
          B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
          B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
          <<B_Mcht_id/binary, "\,", B_Mcht_txn_date/binary, "\,", B_Mcht_txn_seq/binary>>;
        save ->
          [Mcht_id, Mcht_txn_date, Mcht_txn_seq] = binary:split(Value, [<<"\,">>], [global]),
          B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
          B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
          B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
          {B_Mcht_id, B_Mcht_txn_date, B_Mcht_txn_seq}
      end
    end,
    up_queryId => binary,
    up_respCode => binary,
    up_respMsg => binary,
    up_settleAmt => integer,
    up_settleDate => binary,
    up_traceNo => binary,
    up_traceTime => binary,

    up_query_index_key =>
    fun(Value, O) ->
      case O of
        write ->
          {Mcht_id, Mcht_txn_date, Mcht_txn_seq} = Value,
          B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
          B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
          B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
          <<B_Mcht_id/binary, "\,", B_Mcht_txn_date/binary, "\,", B_Mcht_txn_seq/binary>>;
        save ->
          [Mcht_id, Mcht_txn_date, Mcht_txn_seq] = binary:split(Value, [<<"\,">>], [global]),
          B_Mcht_id = pg_mnesia_utils:do_out_2_model_one_field({Mcht_id, binary}, O),
          B_Mcht_txn_date = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_date, binary}, O),
          B_Mcht_txn_seq = pg_mnesia_utils:do_out_2_model_one_field({Mcht_txn_seq, binary}, O),
          {B_Mcht_id, B_Mcht_txn_date, B_Mcht_txn_seq}
      end
    end,
    txn_status => atom,
    up_accNo => binary
  }.

table_read_config() ->
  #{
    field_map => #{

      mcht_index_key => <<"mcht_index_key">>
      , txn_type => <<"txn_type">>

      , up_merId => <<"up_merId">>
      , up_txnTime => <<"up_txnTime">>
      , up_orderId => <<"up_orderId">>
      , up_txnAmt => <<"up_txnAmt">>
      , up_reqReserved => <<"up_reqReserved">>
      , up_orderDesc => <<"up_orderDesc">>
      , up_issInsCode => <<"up_issInsCode">>
      , up_index_key => <<"up_index_key">>

      , up_queryId => <<"up_queryId">>
      , up_respCode => <<"up_respCode">>
      , up_respMsg => <<"up_respMsg">>
      , up_settleAmt => <<"up_settleAmt">>
      , up_settleDate => <<"up_settleDate">>
      , up_traceNo => <<"up_traceNo">>
      , up_traceTime => <<"up_traceTime">>

      , up_query_index_key => <<"up_query_index_key">>

      , txn_status => <<"txn_status">>
      , up_accNo => <<"up_accNo">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  up_txn_log.