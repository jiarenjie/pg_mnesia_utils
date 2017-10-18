%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十月 2017 10:27
%%%-------------------------------------------------------------------
-module(table_mcht_txn_log).
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
  }.

table_read_config() ->
  #{
    field_map => #{

      mcht_index_key => <<"mcht_index_key">>
      , txn_type => <<"txn_type">>
      , mcht_id => <<"mcht_id">>
      , mcht_txn_date => <<"mcht_txn_date">>
      , mcht_txn_time => <<"mcht_txn_time">>
      , mcht_txn_seq => <<"mcht_txn_seq">>
      , mcht_txn_amt => <<"mcht_txn_amt">>
      , mcht_order_desc => <<"mcht_order_desc">>
      , gateway_id => <<"gateway_id">>
      , bank_id => <<"bank_id">>
      , prod_id => <<"prod_id">>
      , prod_bank_acct_id => <<"prod_bank_acct_id">>
      , prod_bank_acct_corp_name => <<"prod_bank_acct_corp_name">>
      , prod_bank_name => <<"prod_bank_name">>
      , mcht_back_url => <<"mcht_back_url">>
      , mcht_front_url => <<"mcht_front_url">>
      , prod_memo => <<"prod_memo">>

      , query_id => <<"query_id">>
      , settle_date => <<"settle_date">>
      , quota => <<"quota">>
      , resp_code => <<"resp_code">>
      , resp_msg => <<"resp_msg">>

      , orig_mcht_txn_date => <<"orig_mcht_txn_date">>
      , orig_mcht_txn_seq => <<"orig_mcht_txn_seq">>
      , orig_query_id => <<"orig_query_id">>

      , txn_status => <<"txn_status">>
      , bank_card_no => <<"bank_card_no">>
    }
    , delimit_field => [<<$^, $^>>]
    , delimit_line => [<<$$, $\n>>]
    , headLine => 1
    , skipTopLines => 1
  }.

table_name() ->
  mcht_txn_log.