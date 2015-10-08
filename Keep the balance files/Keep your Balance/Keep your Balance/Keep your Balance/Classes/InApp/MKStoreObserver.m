//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"
#import "IntroScene.h"
#import "Store.h"
//#import "GameDocument.h"

@implementation MKStoreObserver

static NSString *feature100 = @"com.stayinline.gold100"; //non
static NSString *feature500 = @"com.stayinline.gold500";
static NSString *feature1500 = @"com.stayinline.gold1500";
static NSString *feature10000 = @"com.stayinline.gold10000";
static NSString *feature500000 = @"com.stayinline.gold500000";
static NSString *feature50000 = @"com.stayinline.gold50000";
static NSString *feature200000 = @"com.stayinline.gold200000";
static NSString *feature1000000 = @"com.stayinline.gold1000000";


#pragma mark Data Create


#pragma mark Payment

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				
                [self completeTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateFailed:
				
//                if (transaction.error.code == SKErrorPaymentCancelled){
//                    if(DEBUG) NSLog(@"Transaction failed => Payment cancelled.");
//                }else if (transaction.error.code == SKErrorPaymentInvalid){
//                    if(DEBUG) NSLog(@"Transaction failed => Payment invalid.");
//                }else if (transaction.error.code == SKErrorPaymentNotAllowed){
//                    if(DEBUG) NSLog(@"Transaction failed => Payment not allowed.");
//                }else if (transaction.error.code == SKErrorClientInvalid){
//                    if(DEBUG) NSLog(@"Transaction failed => client invalid.");
//                }else if (transaction.error.code == SKErrorUnknown){
//                    if(DEBUG) NSLog(@"Transaction failed => unknown error.");
//                }else{
//                    if(DEBUG) NSLog(@"I have no idea.");
//                }

                [self failedTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateRestored:
				
                [self restoreTransaction:transaction];
				
            default:
				
                break;
		}			
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    buyClicked = NO;
    
    if (transaction.error.code != SKErrorPaymentCancelled){	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The upgrade procedure failed" message:@"Please check your Internet connection and your App Store account information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		//[alert release];
	}	
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
    
    //AppController* del = (AppController*)[UIApplication sharedApplication].delegate;
//    [del.m_ctrlThinking setHidden:YES];
//    [del.m_ctrlThinking stopAnimating];

}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{		
    [[MKStoreManager sharedManager] provideContent: transaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
    
    //AppController* del = (AppController*)[UIApplication sharedApplication].delegate;
   // [[GameDocument sharedGameDocument] setGameLife:1];
    buyClicked = NO;
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    
    if(transaction.payment.productIdentifier == feature100)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+100;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature10000)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+10000;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature1000000)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+1000000;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature1500)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+1500;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature200000)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+200000;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature500)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+500;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature50000)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+50000;
        [u setInteger:life forKey:@"Gold"];
    }
    else if(transaction.payment.productIdentifier == feature500000)
    {
        long life = [u integerForKey:@"Gold"];
        life = life+500000;
        [u setInteger:life forKey:@"Gold"];
    }
//    [del.m_ctrlThinking setHidden:YES];
//    [del.m_ctrlThinking stopAnimating];
    [u synchronize];

}

-(void)writeToTopScorePlist
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SwiftyBirdADS.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SwiftyBirdADS" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path ];
    [data setObject:@"True" forKey:@"SwiftyBirdADS"];
    [data writeToFile:path atomically:YES];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{	
    [[MKStoreManager sharedManager] provideContent: transaction.originalTransaction.payment.productIdentifier];	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
    
   // AppController* del = (AppController*)[UIApplication sharedApplication].delegate;
//    [del.m_ctrlThinking setHidden:YES];
//    [del.m_ctrlThinking stopAnimating];

}

@end
