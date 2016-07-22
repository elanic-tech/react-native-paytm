
# react-native-paytm


## Getting started

Alert: Built and tested only for iOS.
`$ npm install react-native-paytm --save`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-paytm` and add `RNPayTm.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPayTm.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<
      

## Usage
```javascript
import paytm from 'react-native-paytm';

var details = {
    generationUrl: "http://somegenerationurl.in/checksumGenerator",
    validationUrl: "http://somegenerationurl.in/checksumValidator",
    mid: "YOUR_REGISTERED_MID", // Prod
    industryType: "YOUR_REGISTERED_INDUSTRY", //Prod
    website: "YOUR_REGISTERED_WEBSITE", //prod
    channel: "Your_REGISTERED_CHANNEL",
    amount: "5",
    orderId: "someuniquestring",
    requestType: "DEFAULT",
    email: "mailz4sreejith@gmail.com",
    phone: "9988755334",
    theme: "merchant",
    custId: "9988344556",
};
paytm.startPayment(details);
```
  