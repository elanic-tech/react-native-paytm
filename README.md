
# react-native-paytm
This library has been forked from https://github.com/elanic-tech/react-native-paytm
I have fixed some issues, updated the iOS bridge (event emitter), updated Paytm iOS sdk for bitcode and x86-x64, added an example with PHP code on how to generate payment request

## Getting started

Alert: Built and tested only for iOS.

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-paytm` and add `RNPayTm.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPayTm.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<
      

#### Android
1. Manually link and add react native to your project

## Usage
```javascript
import paytm from 'react-native-paytm';

var details = {
    mid: data.MID,
    industryType: data.INDUSTRY_TYPE_ID, //Prod
    website: data.WEBSITE, //prod
    channel: data.CHANNEL_ID,
    amount: data.TXN_AMOUNT,
    orderId: data.ORDER_ID,
    email: data.EMAIL,
    phone: data.MOBILE_NO,
    custId: data.CUST_ID,
    checksumhash: data.CHECKSUM,
    callback: data.CALLBACK_URL,
};
paytm.startPayment(details);
```
  
