
#import "RNPayTm.h"
#import "RCTEventDispatcher.h"
#import "RCTEventEmitter.h"

@implementation RNPayTm


PGTransactionViewController* txnController;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startPayment: (NSDictionary *)details)
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
      [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
   
    orderDict[@"MID"] = details[@"mid"];
    orderDict[@"CHANNEL_ID"] = details[@"channel"];
    orderDict[@"INDUSTRY_TYPE_ID"] = details[@"industryType"];
    orderDict[@"WEBSITE"] = details[@"website"];
    orderDict[@"TXN_AMOUNT"] = details[@"amount"];
    orderDict[@"ORDER_ID"] = details[@"orderId"];
    orderDict[@"EMAIL"] = details[@"email"];
    orderDict[@"MOBILE_NO"] = details[@"phone"];
    orderDict[@"CUST_ID"] = details[@"custId"];
    orderDict[@"CHECKSUMHASH"] = details[@"checksumhash"];
    orderDict[@"CALLBACK_URL"] = details[@"callback"];
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeStaging;
    txnController.merchant = mc;
    txnController.delegate = self;
    txnController.title = @"Paytm payment";
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    dispatch_async(dispatch_get_main_queue(), ^{
        [rootVC presentViewController:txnController animated:YES completion:nil];
      });
    
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"PayTMResponse"];
}


-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString {
    
    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Success", @"response":responseString}];
    [txnController dismissViewControllerAnimated:YES completion:nil];
}

//Called when a transaction has completed. response dictionary will be having details about Transaction.
- (void)didSucceedTransaction:(PGTransactionViewController *)controller
		     response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
    
  [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Success", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];
}

//Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller
		     error:(NSError *)error
		  response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
    
    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Failed", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];

}

//Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller
		       error:(NSError *)error
		    response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
    
        [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Cancelled", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller
		       error:(NSError *)error
		    response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
     [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Checksum Finished", @"response":str}];
}

@end
