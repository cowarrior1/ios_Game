//
//  AppDelegate.m
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import <VungleSDK/VungleSDK.h>



@implementation AppDelegate
@synthesize currentLeaderBoard,gameCenterManager,cachedHighestScore,adbottom;
// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
//		CCSetupShowDebugStats: @(YES),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
    
    self.currentLeaderBoard = kEasyLeaderboardID;
    if ([GameCenterManager isGameCenterAvailable]) {
        isGameCenterAvailable = YES;
        self.gameCenterManager = [[GameCenterManager alloc] init];
        [self.gameCenterManager setDelegate:self];
        [self.gameCenterManager authenticateLocalUser];
        
    } else {
        isGameCenterAvailable = NO;
        // The current device does not support Game Center.
    }
    
    NSString* appID = VUNGLE_APP_ID;
    VungleSDK *sdk = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk startWithAppId:appID];
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    if ([u boolForKey:@"ADS"] == NO) {
        [self createAdmobAds];
    }
    
	
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [IntroScene scene];
}

-(void)showVungle
{
    VungleSDK* sdk = [VungleSDK sharedSDK];
    [sdk playAd:self.navController];
}



#pragma mark ADMOB BANNER
#pragma mark ADMOB Banner

-(void)createAdmobAds
{
    
    self.adbottom = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    
    self.adbottom.adUnitID = ADMOB_BANNER;
    //self.adinter.adUnitID = GAME_ADMOB_INTTER;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    
    self.adbottom.rootViewController = self.navController;
    [self.navController.view addSubview:self.adbottom];
    
    [self.adbottom loadRequest:[GADRequest request]];
    
    CGRect frame;
    frame = self.adbottom.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = self.navController.view.frame.size.height - frame.size.height;
    
    self.adbottom.frame = frame;
    [UIView commitAnimations];
    
    //    self.adbottom.alpha = 0.0f;
    //    self.adtop.alpha = 0.0f;
}


-(void)showBanner
{
    if (self.adbottom)
    {
        self.adbottom.alpha = 1.0f;
        //Banner on top
        {
            CGRect frame = self.adbottom.frame;
            frame.origin.y = self.navController.view.frame.size.height;
            frame.origin.x = 0.0f;
            self.adbottom.frame = frame;
            
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationCurveEaseOut
                             animations:^
             {
                 CGRect frame = self.adbottom.frame;
                 frame.origin.y = self.navController.view.frame.size.height - frame.size.height;
                 frame.origin.x = 0.0f;
                 self.adbottom.frame = frame;
             }
                             completion:^(BOOL finished)
             {
                 
                 
             }];
        }
        
    }
}

-(void)hideBanner
{
    if (self.adbottom)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = self.adbottom.frame;
             frame.origin.y = -frame.size.height;
             frame.origin.x = 0.0f;
             self.adbottom.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             
             
         }];
    }
}

-(void)dismissAdView
{
    if (self.adbottom)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGSize s = [[CCDirector sharedDirector] viewSize];
             
             CGRect frame = self.adbottom.frame;
             frame.origin.y = frame.origin.y + frame.size.height ;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
             self.adbottom.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [self.adbottom setDelegate:nil];
             [self.adbottom removeFromSuperview];
             self.adbottom = nil;
             
         }];
    }
    [self.adbottom removeFromSuperview];
    self.adbottom = nil;
}

#pragma mark Leader

- (void) submitHighScore
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    int gameHighScore;
    gameHighScore = (int)[u integerForKey:@"HighScore"];
    
    int64_t nScore = (int64_t)(gameHighScore);
    self.currentLeaderBoard = kEasyLeaderboardID;
    if(gameHighScore > 0)
    {
        [self.gameCenterManager reportScore:nScore  forCategory: self.currentLeaderBoard];
    }
    
}

#pragma mark GameCenter View Controllers
- (void) showLeaderboard {
    
    [self submitHighScore];
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) {
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[navController_ presentModalViewController: leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
	[viewController dismissModalViewControllerAnimated: YES];
}

- (void) scoreReported: (NSError*) error;
{
	if(error == NULL)
	{
		[self.gameCenterManager reloadHighScoresForCategory: self.currentLeaderBoard];
		
	}
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
	if(error == NULL)
	{
		int64_t personalBest= leaderBoard.localPlayerScore.value;
		if([leaderBoard.scores count] >0)
		{
			GKScore* allTime= [leaderBoard.scores objectAtIndex: 0];
			self.cachedHighestScore= allTime.formattedValue;
			[gameCenterManager mapPlayerIDtoPlayer: allTime.playerID];
		}
	}
}

@end
