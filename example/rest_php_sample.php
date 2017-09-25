<?php
function generatePaymentRequest($amount)
{
    $uid_email = 'tejashwi.1991@gmail.com';
    $uid_number = '1234567890';
    $uid = 27;

    //get hash of order id and update it
    $order_hash = 'ORDER-' . crc32($oid) . time(); //Every order id should be unique

    // following files need to be included
    require_once(APPPATH . "/third_party/paytmlib/config_paytm.php");
    require_once(APPPATH . "/third_party/paytmlib/encdec_paytm.php");

    $checkSum = "";
    $paramList = array();

    // Create an array having all required parameters for creating checksum.
    $paramList["MID"] = PAYTM_MERCHANT_MID;
    $paramList["CHANNEL_ID"] = 'WAP';
    $paramList["INDUSTRY_TYPE_ID"] = 'Retail';
    $paramList["WEBSITE"] = 'APP_STAGING';
    $paramList["TXN_AMOUNT"] = $amount;
    $paramList["ORDER_ID"] = $order_hash;
    $paramList["EMAIL"] = $uid_email; //Email ID of customer
    $paramList["MOBILE_NO"] = $uid_number; //Mobile number of customer
    $paramList["CUST_ID"] = $uid; //unique user id
    $paramList["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp";

    $checkSum = getChecksumFromArray($paramList,PAYTM_MERCHANT_KEY);

    $paramList["CHECKSUM"] = $checkSum;

    return $paramList; //this param list will be used in javascript to start paytm transaction
}

function validateTransactionStatusWithPAYTM($ORDERID)
{
    //validate payment status with Paytm using order id
     $paramList = array();
     $paramList['MID'] = PAYTM_MERCHANT_MID;
     $paramList['ORDERID'] = $ORDERID;
     $checkSum = getChecksumFromArray($paramList,PAYTM_MERCHANT_KEY);
     $paramList['CHECKSUMHASH'] = $checkSum;

     $url = PAYTM_STATUS_QUERY_URL . '?JsonData=' .json_encode($paramList);
     $f = file_get_contents($url);
     $f = json_decode($f);
     return $f;
}
?>