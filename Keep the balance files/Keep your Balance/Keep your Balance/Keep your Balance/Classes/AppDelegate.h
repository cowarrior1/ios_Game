//
//  AppDelegate.h
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import <GameKit/GameKit.h>
#import "GADBannerView.h"

@interface AppDelegate : CCAppDelegate<GKLeaderboardViewControllerDelegate,GameCenterManagerDelegate>
{
    GameCenterManager *gameCenterManager;
    NSString *currentLeaderBoard;
    
    bool isGameCenterAvailable;
}

@property (nonatomic, retain) GameCenterManager* gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, retain) NSString* cachedHighestScore;
@property (nonatomic, strong) GADBannerView *adbottom;

-(void)showBanner;
-(void)hideBanner;

-(void)createAdmobAds;
-(void)dismissAdView;

-(void) showLeaderboard;

- (void) submitHighScore;

-(void)showVungle;

@end
