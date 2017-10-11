%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 10:37
%%%-------------------------------------------------------------------
-author("jiarj").

table_deal_config(history_mcht_txn_log) ->
  table_deal_config(mcht_txn_log);
table_deal_config(history_up_txn_log) ->
  table_deal_config(up_txn_log);
table_deal_config(history_ums_reconcile_result) ->
  table_deal_config(ums_reconcile_result);
table_deal_config(ums_reconcile_result) ->
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
  };
table_deal_config(mcht_txn_acc) ->
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
  };
table_deal_config(users) ->
  #{
    id => integer,
    name => binary,
    email => binary,
    password => binary,
    role => atom,
    status => atom,
    last_update_ts => ts,
    last_login_ts => ts
  };
table_deal_config(mchants) ->
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
  };

table_deal_config(mcht_txn_log) ->
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
    mcht_id => binary,
    mcht_txn_date => binary,
    mcht_txn_time => binary,
    mcht_txn_seq => binary,
    mcht_txn_amt => integer,
    mcht_order_desc => binary,
    gateway_id => binary,
    bank_id => binary,
    prod_id => binary,
    prod_bank_acct_id => binary,
    prod_bank_acct_corp_name => binary,
    prod_bank_name => binary,
    mcht_back_url => binary,
    mcht_front_url => binary,
    prod_memo => binary,

    query_id => binary,
    settle_date => binary,
    quota => integer,
    resp_code => binary,
    resp_msg => binary,

    orig_mcht_txn_date => binary,
    orig_mcht_txn_seq => binary,
    orig_query_id => binary,

    txn_status => atom,
    bank_card_no => binary
  };
table_deal_config(up_txn_log) ->
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

table_read_config(history_mcht_txn_log) ->
  table_read_config(mcht_txn_log);
table_read_config(history_up_txn_log) ->
  table_read_config(up_txn_log);
table_read_config(history_ums_reconcile_result) ->
  table_read_config(ums_reconcile_result);
table_read_config(ums_reconcile_result) ->
%%  [id,settlement_date,txn_date,txn_time,ums_mcht_id,term_id,
%%    bank_card_no,txn_amt,txn_type,txn_fee,term_batch_no,
%%    term_seq,sys_trace_no,ref_id,auth_resp_code,cooperate_fee,
%%    cooperate_mcht_id,up_txn_seq,ums_order_id,memo]
  #{
    field_map => #{
      id => <<"column1">>
      , settlement_date => <<"column2">>
      , txn_date => <<"column3">>
      , txn_time => <<"column4">>
      , ums_mcht_id => <<"column5">>
      , term_id => <<"column6">>

      , bank_card_no => <<"column7">>
      , txn_amt => <<"column8">>
      , txn_type => <<"column9">>
      , txn_fee => <<"column10">>
      , term_batch_no => <<"column11">>

      , term_seq => <<"column12">>
      , sys_trace_no => <<"column13">>
      , ref_id => <<"column14">>
      , auth_resp_code => <<"column15">>
      , cooperate_fee => <<"column16">>

      , cooperate_mcht_id => <<"column17">>
      , up_txn_seq => <<"column18">>
      , ums_order_id => <<"column19">>
      , memo => <<"column20">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  };
table_read_config(mcht_txn_acc) ->
%%  [acc_index,mcht_id,txn_type,month_date,acc]
  #{
    field_map => #{
      acc_index => <<"column1">>
      , mcht_id => <<"column2">>
      , txn_type => <<"column3">>
      , month_date => <<"column4">>
      , acc => <<"column5">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  };
table_read_config(users) ->
%%  [id,name,email,password,role,status,last_update_ts, last_login_ts]
  #{
    field_map => #{
      id => <<"column1">>
      , name => <<"column2">>
      , email => <<"column3">>
      , password => <<"column4">>
      , role => <<"column5">>
      , status => <<"column6">>
      , last_update_ts => <<"column7">>
      , last_login_ts => <<"column8">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  };
table_read_config(mchants) ->
  #{
    field_map => #{
      id => <<"column1">>
      , mcht_full_name => <<"column2">>
      , mcht_short_name => <<"column3">>
      , status => <<"column4">>
      , payment_method => <<"column5">>
      , up_mcht_id => <<"column6">>
      , quota => <<"column7">>
      , up_term_no => <<"column8">>
      , update_ts => <<"column9">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  };
table_read_config(mcht_txn_log) ->
  #{
    field_map => #{

      mcht_index_key => <<"column1">>
      , txn_type => <<"column2">>
      , mcht_id => <<"column3">>
      , mcht_txn_date => <<"column4">>
      , mcht_txn_time => <<"column5">>
      , mcht_txn_seq => <<"column6">>
      , mcht_txn_amt => <<"column7">>
      , mcht_order_desc => <<"column8">>
      , gateway_id => <<"column9">>
      , bank_id => <<"column10">>
      , prod_id => <<"column11">>
      , prod_bank_acct_id => <<"column12">>
      , prod_bank_acct_corp_name => <<"column13">>
      , prod_bank_name => <<"column14">>
      , mcht_back_url => <<"column15">>
      , mcht_front_url => <<"column16">>
      , prod_memo => <<"column17">>

      , query_id => <<"column18">>
      , settle_date => <<"column19">>
      , quota => <<"column20">>
      , resp_code => <<"column21">>
      , resp_msg => <<"column22">>

      , orig_mcht_txn_date => <<"column23">>
      , orig_mcht_txn_seq => <<"column24">>
      , orig_query_id => <<"column25">>

      , txn_status => <<"column26">>
      , bank_card_no => <<"column27">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  };
table_read_config(up_txn_log) ->
  #{
    field_map => #{

      mcht_index_key => <<"column1">>
      , txn_type => <<"column2">>

      , up_merId => <<"column3">>
      , up_txnTime => <<"column4">>
      , up_orderId => <<"column5">>
      , up_txnAmt => <<"column6">>
      , up_reqReserved => <<"column7">>
      , up_orderDesc => <<"column8">>
      , up_issInsCode => <<"column9">>
      , up_index_key => <<"column10">>

      , up_queryId => <<"column11">>
      , up_respCode => <<"column12">>
      , up_respMsg => <<"column13">>
      , up_settleAmt => <<"column14">>
      , up_settleDate => <<"column15">>
      , up_traceNo => <<"column16">>
      , up_traceTime => <<"column17">>

      , up_query_index_key => <<"column18">>

      , txn_status => <<"column19">>
      , up_accNo => <<"column20">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
  }.