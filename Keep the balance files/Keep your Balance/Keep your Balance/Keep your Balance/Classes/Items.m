//
//  IntroScene.m
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "Items.h"
#import "IntroScene.h"
#import "Store.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation Items
{
    float m_scaleX;
    float m_scaleY;
    
    long gold;
    CCLabelTTF *coinLabel;
    
    NSUserDefaults *u;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Items *)scene
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
    CCSprite *background = [CCSprite spriteWithImageNamed:@"items_bg.png"];
    background.scaleX = self.contentSize.width/background.contentSize.width;
    background.scaleY = self.contentSize.height/background.contentSize.height;
    background.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:background];
    
    [self setImageScale];
    
    gold = [u integerForKey:@"Gold"];
    
    coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"GOLD: %ld",(long)[u integerForKey:@"Gold"]] fontName:@"Verdana-Bold" fontSize:24.0f*m_scaleX];
    coinLabel.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.95f);
    [self addChild:coinLabel];
    
    CCButton *buyads;
    if ([u boolForKey:@"ADS"] == YES) {
        buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy1_checked.png"]];
    }
    else
    {
        buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy1_normal.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy1_checked.png"] disabledSpriteFrame:nil];
        [buyads setTarget:self selector:@selector(onBuyAds:)];
    }
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.77f);
    [self addChild:buyads];
    
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy2_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuySaveMe:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.7f);
    [self addChild:buyads];
    
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy3_normal.png"] ];
    [buyads setTarget:self selector:@selector(onBuySlow1:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.63f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy4_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuySlow2:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.545f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy5_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuySlow5:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.477f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy6_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuyDontDie:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.41f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy7_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuyFly:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.34f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy8_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuySaveMe5:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.255f);
    [self addChild:buyads];
    
    buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy9_normal.png"]];
    [buyads setTarget:self selector:@selector(onBuyTry:)];
    
    buyads.togglesSelectedState = YES;
    buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
    buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.19f);
    [self addChild:buyads];
    
    CCButton *back = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"back.png"]];
    back.scaleX = m_scaleX; back.scaleY = m_scaleY;
    back.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.1f);
    [back setTarget:self selector:@selector(onBack:)];
    [self addChild:back];
    
    CCButton *shop = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buygold_bt.png"]];
    shop.scaleX = m_scaleX; shop.scaleY = m_scaleY;
    shop.position = ccp(self.contentSize.width*0.8f, self.contentSize.height*0.9f);
    [shop setTarget:self selector:@selector(onShop:)];
    [self addChild:shop];
    
    // done
	return self;
}

-(void)setImageScale
{
    m_scaleX = self.contentSize.width/640.0f;
    m_scaleY = self.contentSize.height/1024.0f;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)setGold:(int)sender
{
    gold = gold - sender;
    [u setInteger:gold forKey:@"Gold"];
    [u synchronize];
    [coinLabel setString:[NSString stringWithFormat:@"GOLD: %ld",gold]];
}

-(void)onBuyAds:(id)sender
{
    
    if (gold>=1000) {
        [self setGold:1000];
        [u setBool:YES forKey:@"ADS"];
        [u synchronize];
        
//        if ([u boolForKey:@"ADS"] == NO) {
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [app hideBanner];
            [app dismissAdView];
//        }
        
        [sender removeFromParentAndCleanup:YES];
        CCButton *buyads;
        buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy1_checked.png"]];
        buyads.togglesSelectedState = YES;
        buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
        buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.77f);
        [self addChild:buyads];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuySaveMe:(id)sender
{
    if (gold>=600) {
        [self setGold:600];
        [u setInteger:([u integerForKey:@"SaveMe"]+1) forKey:@"SaveMe"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuySlow1:(id)sender
{
    if (gold>=850) {
        [self setGold:850];
        [u setInteger:([u integerForKey:@"SlowMotion"]+1) forKey:@"SlowMotion"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuySlow2:(id)sender
{
    if (gold>=1500) {
        [self setGold:1500];
        [u setInteger:([u integerForKey:@"SlowMotion"]+2) forKey:@"SlowMotion"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuySlow5:(id)sender
{
    if (gold>=4500) {
        [self setGold:4500];
        [u setInteger:([u integerForKey:@"SlowMotion"]+5) forKey:@"SlowMotion"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuyDontDie:(id)sender
{
    if (gold>=15000) {
        [self setGold:15000];
        [u setInteger:([u integerForKey:@"DontDie"]+2) forKey:@"DontDie"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuyFly:(id)sender
{
    if (gold>=25000) {
        [self setGold:25000];
        [u setInteger:([u integerForKey:@"Fly"]+1) forKey:@"Fly"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuySaveMe5:(id)sender
{
    if (gold>=57000) {
        [self setGold:57000];
        [u setInteger:([u integerForKey:@"SaveMe2"]+1) forKey:@"SaveMe2"];
        [u synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBuyTry:(id)sender
{
    if (gold>=2000) {
        [self setGold:2000];
        [u setInteger:([u integerForKey:@"Try"] + 1) forKey:@"Try"];
        [u synchronize];
        
        [sender removeFromParentAndCleanup:YES];
        CCButton *buyads;
        buyads = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"item_buy9_checked.png"]];
        buyads.togglesSelectedState = YES;
        buyads.scaleX = m_scaleX; buyads.scaleY = m_scaleY;
        buyads.position = ccp(self.contentSize.width*0.88f, self.contentSize.height*0.19f);
        [self addChild:buyads];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
    }
}

-(void)onBack:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onShop:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[Store node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

// -----------------------------------------------------------------------
@end
