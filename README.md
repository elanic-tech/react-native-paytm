
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
      

#### Android
1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.reactlibrary.RNPayTmPackage;` to the imports at the top of the file
2. Append the following lines to `android/settings.gradle`:
    ```gradle
    include ':react-native-paytm'
    project(':react-native-paytm').projectDir = new File(rootProject.projectDir,   '../node_modules/react-native-paytm/android')
    ```
3. Insert the following lines inside the dependencies block in
`android/app/build.gradle`:
    ```gradle
    compile project(':react-native-paytm')
    ```

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
  
