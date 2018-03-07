
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
    this.addListenerOn(DeviceEventEmitter, 'keyboardWillShow', this.onPayTmResponse);
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
  
