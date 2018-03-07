
# react-native-paytm
This library has been forked from https://github.com/elanic-tech/react-native-paytm
Updated it to work with the latest version of react-native and latest PayTM SDK. Improved the documentaion as well.

## Getting started

Alert: Built and tested only for iOS.

### installation

#### Android
````bash
react-native link react-native-paytm
````

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-paytm` and add `RNPayTm.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPayTm.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<
      

## Usage
```javascript
import paytm from 'react-native-paytm';
import { ..., DeviceEventEmitter, ... } from 'react-native';

....

static paytmConfig = {
  MID: "...",
  WEBSITE: "...",
  CHANNEL_ID: "...",
  INDUSTRY_TYPE_ID: "...",
  CALLBACK_URL: "...",
};

componentWillMount(){
    ...
    DeviceEventEmitter.addListener('PayTMResponse', this.onPayTmResponse);
    ...
};

onPayTmResponse(response) {
  // Process Response
  console.log(response);
}

runTransaction(amount, customerId, orderId, mobile, email, checkSum) {
    var details = {
        mode: 'Staging', // 'Staging' or 'Production'
        mid: paytmConfig.MID,
        industryType: paytmConfig.INDUSTRY_TYPE_ID, //Prod
        website: paytmConfig.WEBSITE, //prod
        channel: paytmConfig.CHANNEL_ID,
        amount: amount,
        orderId: orderId,
        email: email,
        phone: mobile,
        custId: customerId,
        checksumhash: checkSum,
        callback: paytmConfig.CALLBACK_URL,
    };
    paytm.startPayment(details);
}
```
  
