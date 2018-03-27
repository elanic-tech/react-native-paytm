/*
This is a sample code for reference about how to properly use Paytm with React Native
*/

import React, { Component } from 'react';
import { TouchableHighlight, Alert, View, Text, StyleSheet, Dimensions, NativeModules,ActivityIndicator, DeviceEventEmitter, TextInput } from 'react-native';
import paytm from 'react-native-paytm';
var {height, width} = Dimensions.get('window');


var paytmEvent = null;

class Button extends Component{
    render(){
        return (
            <TouchableHighlight onPress={this.props.onPress} underlayColor='transparent' style={{marginTop: 16, alignItems:'center', justifyContent:'center'}}>
                <View style={styles.buttonContainer}>
                    <Text style={styles.upperText}> {this.props.text} </Text>
                </View>
            </TouchableHighlight>
        );
    }
}


class Addmoney extends Component{
    constructor(props){
        super(props);
        this.state = {
             amount: 0,
             order_id: '',
             processing: false,
             payment_text: 'Requesting payment, please wait...'
        };

        this._setAmount = this._setAmount.bind(this);

        this._startPayment = this._startPayment.bind(this);
        this._handlePaytmResponse = this._handlePaytmResponse.bind(this);

    }
    componentDidMount(){
        paytmEvent = new NativeEventEmitter(NativeModules.RNPayTm);
        paytmEvent.addListener('PayTMResponse', this._handlePaytmResponse);
    }
    componentWillUnmount(){
        if(paytmEvent){
            paytmEvent.removeListener('PayTMResponse', this._handlePaytmResponse);
            paytmEvent = null;
        }
    }
    _setAmount(much){
        this.setState({amount: much});
        this._amountTxtBox.setNativeProps({text:much.toString()});
    }
    _startPayment(){
        if(this.state.processing) return;

        var uid = 27; //user id for user who is initiating the payment
        var api_key = 'sample_api_key'; //any API key to authenticate REST end point
        var amount = parseInt(this.state.amount);
       
        if(amount == 0 || amount == ''){
            Alert.alert('Please select or enter a valid amount'); return;
        }
        if(amount < 10){
          Alert.alert('Minimum purchase limit is 10 rupees'); return;
        }
        if(amount > 1000){
          Alert.alert('Maximum purchase limit is 1000 rupees'); return;
        }

        amount = amount.toString(); //amount must be passed a string else paytm will crash if amount is int type

        this.setState({processing: true, payment_text: 'Requesting payment, please wait...'});
        var type = 1; //credit
        //start transaction, generate request from server
        api.generatePaymentRequest(uid, api_key, amount, type)
            .then(response => {
                if(response.responseCode == 401){
                    Alert.alert('Unauthorized REST API request');
                }
                else{
                    //this response from REST endpoint will contain all the required data to start payment
                    //please check php file for sample
                    var data = response.paramList;
                    this.setState({order_id: data.ORDER_ID});

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
                }
            })
            .catch(err => {
                this.setState({processing: false});
                Alert.alert('Error', 'Unable to initiate transaction, please try again');
            });
    }
    _handlePaytmResponse(body){
        var uid = 27; //user id for user who is initiating the payment
        var api_key = 'sample_api_key'; //any API key to authenticate REST end point
        var order_id = this.state.order_id;

        this.setState({payment_text: 'Verifying payment status, please wait...'});
        api.verifyPaymentRequest(uid, api_key, order_id)
            .then(response => {
                if(response.responseCode == 401){
                    Alert.alert('Unauthorized REST API request');
                }
                else{
                    var result = response.result;
                    if(result == "Success"){
                        Alert.alert('Transaction successful', 'We have added money to your account, enjoy your game');
                    }else{
                        console.log(body); //check paytm response for any fail case message and details
                        Alert.alert('Failed', result);
                    }
                    this.setState({processing: false, payment_text: ''});
                }
            })
            .catch(err => {
                this.setState({processing: false, payment_text: ''});
                Alert.alert('Error', 'Unable to complete transaction, please check your bills. In case of any query you can contact us');
            });
    }
    render(){
        return(
        <View style={styles.container}>
            <View style={{flex: 1}}>
                <TextInput ref={component=> this._amountTxtBox=component}
                    style={{height: 50, backgroundColor: '#EDEDED', color: 'black', marginLeft: 0, marginRight:0, marginTop: 20}}
                    onChangeText={(text) => this.setState({amount: text})}
                    autoCorrect={false}
                    placeholder=" Enter Amount"
                    placeholderTextColor="#727278"
                    keyboardType="numeric"
                />
                <View style={{width: width, flex: 1}}>
                    {(this.state.processing) ? (
                        <View style={{alignItems:'center', justifyContent: 'center'}}>
                            <ActivityIndicator
                                animating={this.state.processing}
                                style={{height: 80}}
                                color="black"
                                size="large"/>
                            <Text style={{marginTop: 5, fontSize: 15, fontWeight: 'bold'}}>{this.state.payment_text}</Text>
                        </View>
                    ) : (<Button text="Pay via PayTM" onPress={this._startPayment}/>) }
                </View>
            </View>
        </View>
        );
    }
}
const styles = StyleSheet.create({
  container: {
    flex: 1,
    width: null,
    height: null,
  },
  buttonContainer:{
    borderRadius: 5,
    backgroundColor: "black",
    width: 200,
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000000',
    shadowOffset: {
      width: 0,
      height: 10
    },
    shadowRadius: 10,
    shadowOpacity: 0.2,
  },
  upperText:{
    color:"white",
    fontSize: 15,
  },
});

module.exports = Addmoney;
