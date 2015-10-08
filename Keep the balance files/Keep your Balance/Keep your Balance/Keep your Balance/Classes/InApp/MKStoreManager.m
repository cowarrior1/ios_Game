

#import "MKStoreManager.h"
#import "AppDelegate.h"
//#import "ShareData.h"

BOOL buyClicked = NO;

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;


static NSString *feature100 = @"com.stayinline.gold100."; //non
static NSString *feature500 = @"com.stayinline.gold500.";
static NSString *feature1500 = @"com.stayinline.gold1500.";
static NSString *feature10000 = @"com.stayinline.gold10000.";
static NSString *feature500000 = @"com.stayinline.gold500000.";
static NSString *feature50000 = @"com.stayinline.gold50000.";
static NSString *feature200000 = @"com.stayinline.gold200000.";
static NSString *feature1000000 = @"com.stayinline.gold1000000.";
static NSString *featureBirdAllId = @"com.ima.";
static NSString *featureCameraAllId = @"com.ima.";
static NSString *featureCoinId = @"SWBCOIN1000";
static NSString *featureADS = @"SWBNOAD01";

//BOOL featureAPurchased = false;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	//[storeObserver release];
	//[super dealloc];
}

//+ (BOOL) featureAPurchased {
//	
//	return featureAPurchased;
//}


+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}





- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: feature100,feature10000,feature1000000,feature1500,feature200000,feature500,feature50000,feature500000, nil]]; // add any other product here
//    [NSSet setWithObjects: featureAId, featureBId, featureCId, featureDId, featureEId, featureFId, featureGId, featureHId, nil]]; // add any other
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
}

-(void) buyNOADS
{
    [self buyFeature:featureADS];
}

- (void) buyFeatureAllCamera
{
    //featureAPurchased = NO;
	[self buyFeature:featureCameraAllId];
}

- (void) buyFeatureBirdAll
{
//    featureBPurchased = NO;
	[self buyFeature:featureBirdAllId];
    
}

- (void) buyFeature100
{
//    featureCPurchased = NO;
	[self buyFeature:feature100];
}

- (void) buyFeature500
{
//    featureDPurchased = NO;
	[self buyFeature:feature500];
}

- (void) buyFeature1500
{
//    featureEPurchased = NO;
	[self buyFeature:feature1500];
}

- (void) buyFeature10000
{
//    featureFPurchased = NO;
	[self buyFeature:feature10000];
}

- (void) buyFeature500000
{
    //    featureGPurchased = NO;
	[self buyFeature:feature500000];
}

- (void) buyFeature50000
{
//    featureGPurchased = NO;
	[self buyFeature:feature50000];
}

- (void) buyFeature200000
{
//    featureHPurchased = NO;
	[self buyFeature:feature200000];
}

- (void) buyFeature1000000
{
    //    featureHPurchased = NO;
	[self buyFeature:feature1000000];
}

- (void) buyFeatureCoin
{
    //    featureHPurchased = NO;
	[self buyFeature:featureCoinId];
}

- (void) buyFeatureExtraLife
{
    //    featureHPurchased = NO;
//	[self buyFeature:featureExtralifeId];
}

- (void) buyFeature:(NSString*) featureId
{
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions]; 

	if ([SKPaymentQueue canMakePayments])
	{
        
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
//        [payment.quantity ];
        NSLog(@"******* %ld", (long)[payment quantity]);
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        //AppController* del = (AppController*)[UIApplication sharedApplication].delegate;
//        [del.m_ctrlThinking setHidden:YES];
//        [del.m_ctrlThinking stopAnimating];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
}

-(void) provideContent: (NSString*) productIdentifier
{
//	if([productIdentifier isEqualToString:featureAId])
//    {
//		featureAPurchased = YES;
//    }

	[MKStoreManager updatePurchases];
}


+(void) loadPurchases 
{
	//NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//featureAPurchased = [userDefaults boolForKey:featureAId];
}


+(void) updatePurchases
{
	//NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//[userDefaults setBool:featureAPurchased forKey:featureAId];
}

- (void) restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
@end
