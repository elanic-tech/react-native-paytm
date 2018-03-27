
package com.reactlibrary;

import java.util.HashMap;
import java.util.Map;
import android.app.Activity;
import javax.annotation.Nullable;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import com.paytm.pgsdk.PaytmClientCertificate;
import com.paytm.pgsdk.PaytmMerchant;
import com.paytm.pgsdk.PaytmOrder;
import com.paytm.pgsdk.PaytmPGService;
import com.paytm.pgsdk.PaytmPaymentTransactionCallback;

public class RNPayTmModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNPayTmModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNPayTm";
  }

  @ReactMethod
  public void startPayment(ReadableMap options) {
    Activity currentActivity = getCurrentActivity();
    PaytmPGService Service;
    if(options.getString("mode").equals("Production")){
        Service = PaytmPGService.getProductionService();
    } else {
        Service = PaytmPGService.getStagingService();
    }
    Map<String, String> paramMap = new HashMap<String, String>();
    paramMap.put("ORDER_ID", options.getString("orderId"));
    paramMap.put("MID", options.getString("mid"));
    paramMap.put("CUST_ID", options.getString("custId"));
    paramMap.put("CHANNEL_ID", options.getString("channel"));
    paramMap.put("INDUSTRY_TYPE_ID", options.getString("industryType"));
    paramMap.put("WEBSITE", options.getString("website"));
    paramMap.put("TXN_AMOUNT", options.getString("amount"));
    paramMap.put("EMAIL", options.getString("email"));
    paramMap.put("MOBILE_NO", options.getString("phone"));
    paramMap.put("CALLBACK_URL", options.getString("callback"));
    paramMap.put("CHECKSUMHASH", options.getString("checksumhash"));
    PaytmOrder Order = new PaytmOrder(paramMap);

/*
    PaytmMerchant Merchant = new PaytmMerchant(
        options.getString("generationUrl"),
        options.getString("validationUrl"));

    Service.initialize(Order, Merchant, null);
*/
    Service.initialize(Order, null);

    Service.startPaymentTransaction(getCurrentActivity(), true, true, new PaytmPaymentTransactionCallback() {
      @Override
      public void someUIErrorOccurred(String inErrorMessage) {
        Log.d("LOG", "PayTM Error: Some UI Error Occurred " + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "UIErrorOccurred");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void onTransactionResponse(Bundle inResponse) {
        Log.d("LOG", "Payment Transaction Resnponse " + inResponse);
        WritableMap params = Arguments.fromBundle(inResponse);
        params.putString("status", "Response");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void networkNotAvailable() {
        Log.d("LOG", "Network Not Available");
        WritableMap params = new WritableNativeMap();
        params.putString("status", "NetworkNotAvailable");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void clientAuthenticationFailed(String inErrorMessage) {
        Log.d("LOG", "Clinet Authentication Failed" + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "ClientAuthenticationFailed");
        sendEvent( "PayTMResponse", params );
      }

      @Override
      public void onErrorLoadingWebPage(int iniErrorCode, String inErrorMessage, String inFailingUrl) {
        Log.d("LOG", "Error Loading WebPage" + inErrorMessage);
        WritableMap params = new WritableNativeMap();
        params.putString("status", "ErrorLoadingWebPage");
        sendEvent( "PayTMResponse", params );
      }

      // had to be added: NOTE
      @Override
      public void onBackPressedCancelTransaction() {
        Log.d("LOG", "Cancelled: Back");
        WritableMap params = new WritableNativeMap();
        params.putString("status", "Cancelled: Back");
        sendEvent( "PayTMResponse", params);
      }

      @Override
      public void onTransactionCancel(String inErrorMessage, Bundle inResponse) {
        Log.d("LOG", "Cancelled: " + inErrorMessage);
        WritableMap params = Arguments.fromBundle(inResponse);
        params.putString("status", "Cancelled");
        sendEvent( "PayTMResponse", params);
      }
    });      
  }

  private void sendEvent(String eventName, @Nullable WritableMap params) {
  reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }
   
}
