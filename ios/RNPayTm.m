
#import "RNPayTm.h"
#import "RCTEventDispatcher.h"

@implementation RNPayTm


PGTransactionViewController* txnController;

@synthesize bridge = _bridge;
/*
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
*/
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startPayment: (NSDictionary *)details)
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
      [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    //Step 1: Create a default merchant config object
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    mc.checksumGenerationURL = details[@"generationUrl"];
    mc.checksumValidationURL = details[@"validationUrl"];

    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    //Written this way to highlight all parameters
    orderDict[@"MID"] = details[@"mid"];
    orderDict[@"CHANNEL_ID"] = details[@"channel"];
    orderDict[@"INDUSTRY_TYPE_ID"] = details[@"industryType"];
    orderDict[@"WEBSITE"] = details[@"website"];
    //Order configuration in the order object
    orderDict[@"TXN_AMOUNT"] = details[@"amount"];
    orderDict[@"ORDER_ID"] = details[@"orderId"];
    orderDict[@"REQUEST_TYPE"] = details[@"requestType"];
    orderDict[@"EMAIL"] = details[@"email"];
    orderDict[@"MOBILE_NO"] = details[@"phone"];
    orderDict[@"THEME"] = details[@"theme"];
    orderDict[@"CUST_ID"] = details[@"custId"];
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = mc;
    txnController.delegate = self;
    txnController.loggingEnabled = true;
    
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    dispatch_async(dispatch_get_main_queue(), ^{
	[rootVC presentViewController:txnController animated:YES completion:nil];
      });
}

//Called when a transaction has completed. response dictionary will be having details about Transaction.
- (void)didSucceedTransaction:(PGTransactionViewController *)controller
		     response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
  [self.bridge.eventDispatcher sendAppEventWithName:@"PayTMResponse"
					       body:@{@"status":@"Success", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];
}

//Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller
		     error:(NSError *)error
		  response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
  [self.bridge.eventDispatcher sendAppEventWithName:@"PayTMResponse"
					       body:@{@"status":@"Failed", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];

}

//Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller
		       error:(NSError *)error
		    response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
  [self.bridge.eventDispatcher sendAppEventWithName:@"PayTMResponse"
					       body:@{@"status":@"Cancelled", @"response":str}];
  [txnController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller
		       error:(NSError *)error
		    response:(NSDictionary *)response{
  NSString *str = [NSString stringWithFormat:@"%@", response];
  [self.bridge.eventDispatcher sendAppEventWithName:@"PayTMResponse"
					       body:@{@"status":@"Checksum Finished", @"response":str}];
}

@end
