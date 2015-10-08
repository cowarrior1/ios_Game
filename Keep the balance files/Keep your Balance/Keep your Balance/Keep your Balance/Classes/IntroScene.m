//
//  IntroScene.m
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "Items.h"
#import "HelloWorldScene.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
{
    NSUserDefaults *u;
    
    float m_scaleX;
    float m_scaleY;
    
    BOOL isPlay;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    u = [NSUserDefaults standardUserDefaults];
    // Create a colored background (Dark Grey)
    CCSprite *background = [CCSprite spriteWithImageNamed:@"main_bg.png"];
    background.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:background];
    
    [self setImageScale];
    
    CCButton *goBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"go_bt.png"]];
    goBt.scaleX = m_scaleX; goBt.scaleY = m_scaleY;
    goBt.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.5f);
    [goBt setTarget:self selector:@selector(onGo:)];
    [self addChild:goBt];
    
    CCButton *storeBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"store_bt.png"]];
    storeBt.scaleX = m_scaleX; storeBt.scaleY = m_scaleY;
    storeBt.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.4f);
    [storeBt setTarget:self selector:@selector(onStore:)];
    [self addChild:storeBt];
    
    CCButton *leaderBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leader_bt.png"]];
    leaderBt.scaleX = m_scaleX; leaderBt.scaleY = m_scaleY;
    leaderBt.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.3f);
    [leaderBt setTarget:self selector:@selector(onLeader:)];
    [self addChild:leaderBt];
    
    CCButton *freeBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"free_bt.png"]];
    freeBt.scaleX = m_scaleX*2.0f; freeBt.scaleY = m_scaleY*2.0f;
    freeBt.position = ccp(self.contentSize.width*0.8f, self.contentSize.height*0.1f);
    [freeBt setTarget:self selector:@selector(onFree:)];
    [self addChild:freeBt z:0 name:@"FreeBT"];
    // done
    
    if ([u boolForKey:@"ADS"] == NO) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        [app createAdmobAds];
        [app showBanner];
    }
    else
    {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        //        [app createAdmobAds];
        [app dismissAdView];
    }
    
    [[OALSimpleAudio sharedInstance]playBg:@"Stay in_the_line.mp3" loop:YES];
    
    [self schedule:@selector(OnTimer:) interval:0.01f];
    
	return self;
}

-(void)setImageScale
{
    m_scaleX = self.contentSize.width/640.0f/2.0f;
    m_scaleY = self.contentSize.height/1024.0f/2.0f;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onGo:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[HelloWorldScene node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onStore:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[Items node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onLeader:(id)sender
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [app showLeaderboard];
}

-(void)onFree:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Free Coins!" message:@"Anytime, Watch a 15 second Trailer to earn 150 coins!"
                                                   delegate:self cancelButtonTitle:@"Yes sure!" otherButtonTitles:@"No Thanks, Maybe later!", nil];
    [alert show];
}

-(void)onExit
{
    NSLog(@"abcd");
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app showVungle];
        isPlay = YES;
        [[OALSimpleAudio sharedInstance]stopBg];
        [u setInteger:(150+[u integerForKey:@"Gold"]) forKey:@"Gold"];
        [u synchronize];
    }
}

-(void)OnTimer:(CCTime)dt
{
    static float tttt = 0.0f;
    if (isPlay) {
        tttt+=dt;
        if (tttt>=6.0f) {
            tttt = 0.0f;
            isPlay = NO;
            [[OALSimpleAudio sharedInstance]playBg:@"Stay in_the_line.mp3" loop:YES];
        }
    }
    // When an ad has not yet been cached, disable buttons
    CCButton *bt = (CCButton*)[self getChildByName:@"FreeBT" recursively:NO];
    
    if (![[VungleSDK sharedSDK] isCachedAdAvailable]) {
        bt.enabled = NO;
        // When an ad has been cached, enable buttons
    } else {
        bt.enabled = YES;
    }
}

// -----------------------------------------------------------------------
@end
