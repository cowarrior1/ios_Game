

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"
//#import "Global.h"

extern BOOL buyClicked;

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	
	
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeature100; // expose product buying functions, do not expose
- (void) buyFeature500; // your product ids. This will minimize changes when you change product ids later
- (void) buyFeature1500;
- (void) buyFeature10000;
- (void) buyFeature500000;
- (void) buyFeature50000;
- (void) buyFeature200000;
- (void) buyFeature1000000;
- (void) buyFeatureCamera;
- (void) buyFeatureCameraRoll;
- (void) buyFeatureAllCamera;
- (void) buyNOADS;
- (void) restore;


// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

//+ (BOOL) featureAPurchased;
//+ (BOOL) featureBPurchased;
//+ (BOOL) featureCPurchased;
//+ (BOOL) featureDPurchased;
//+ (BOOL) featureEPurchased;
//+ (BOOL) featureFPurchased;
//+ (BOOL) featureGPurchased;

//+ (BOOL) ExtraLifePurchased; // expose product buying functions, do not expose
//+ (BOOL) BirdTwoPurchased; // your product ids. This will minimize changes when you change product ids later
//+ (BOOL) BirdThreePurchased;
//+ (BOOL) BirdFourPurchased;
//+ (BOOL) BirdFivePurchased;
//+ (BOOL) BirdSixPurchased;
//+ (BOOL) BirdAllPurchased;
//+ (BOOL) CoinPurchased;
//+ (BOOL) CameraPurchased;
//+ (BOOL) CameraRollPurchased;
//+ (BOOL) AllCameraPurchased;

+(void) loadPurchases;
+(void) updatePurchases;

@end
