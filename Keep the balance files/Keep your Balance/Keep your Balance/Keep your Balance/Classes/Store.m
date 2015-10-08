//
//  IntroScene.m
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "Store.h"
#import "Items.h"
#import "MKStoreManager.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation Store
{
    float m_scaleX;
    float m_scaleY;
    
    NSUserDefaults *u;
    
    CCLabelTTF *coinLabel;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (Store *)scene
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
    CCSprite *background = [CCSprite spriteWithImageNamed:@"store_bg.png"];
    background.scaleX = self.contentSize.width/background.contentSize.width;
    background.scaleY = self.contentSize.height/background.contentSize.height;
    background.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:background];
    
    [self setImageScale];
    
    coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"GOLD: %ld",(long)[u integerForKey:@"Gold"]] fontName:@"Verdana-Bold" fontSize:24.0f*m_scaleX];
    coinLabel.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.95f);
    [self addChild:coinLabel];
    
    CCButton *buy1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy1.png"]];
    buy1.scaleX = m_scaleX; buy1.scaleY = m_scaleY;
    buy1.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.81f);
    [buy1 setTarget:self selector:@selector(onBuy100:)];
    [self addChild:buy1];
    
    CCButton *buy2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy2.png"]];
    buy2.scaleX = m_scaleX; buy2.scaleY = m_scaleY;
    buy2.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.73f);
    [buy2 setTarget:self selector:@selector(onBuy500:)];
    [self addChild:buy2];
    
    CCButton *buy3 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy3.png"]];
    buy3.scaleX = m_scaleX; buy3.scaleY = m_scaleY;
    buy3.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.65f);
    [buy3 setTarget:self selector:@selector(onBuy1500:)];
    [self addChild:buy3];

    CCButton *buy4 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy4.png"]];
    buy4.scaleX = m_scaleX; buy4.scaleY = m_scaleY;
    buy4.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.57f);
    [buy4 setTarget:self selector:@selector(onBuy10000:)];
    [self addChild:buy4];
    
    CCButton *buy5 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy5.png"]];
    buy5.scaleX = m_scaleX; buy5.scaleY = m_scaleY;
    buy5.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.49f);
    [buy5 setTarget:self selector:@selector(onBuy500000:)];
    [self addChild:buy5];
    
    CCButton *buy6 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy4.png"]];
    buy6.scaleX = m_scaleX; buy6.scaleY = m_scaleY;
    buy6.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.34f);
    [buy6 setTarget:self selector:@selector(onBuy50000:)];
    [self addChild:buy6];
    
    CCButton *buy7 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy2.png"]];
    buy7.scaleX = m_scaleX; buy7.scaleY = m_scaleY;
    buy7.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.26f);
    [buy7 setTarget:self selector:@selector(onBuy200000:)];
    [self addChild:buy7];
    
    CCButton *buy8 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"buy5.png"]];
    buy8.scaleX = m_scaleX; buy8.scaleY = m_scaleY;
    buy8.position = ccp(self.contentSize.width*0.75f, self.contentSize.height*0.18f);
    [buy8 setTarget:self selector:@selector(onBuy1000000:)];
    [self addChild:buy8];
    
    CCButton *back = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"back.png"]];
    back.scaleX = m_scaleX; back.scaleY = m_scaleY;
    back.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.1f);
    [back setTarget:self selector:@selector(onBack:)];
    [self addChild:back];
    
    // done
    [self schedule:@selector(onTimer:) interval:0.01f];
    
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

-(void)onBuy100:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature100];
    buyClicked = YES;
}

-(void)onBuy500:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature500];
    buyClicked = YES;
}

-(void)onBuy1500:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature1500];
    buyClicked = YES;
}

-(void)onBuy10000:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature10000];
    buyClicked = YES;
}

-(void)onBuy500000:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature500000];
    buyClicked = YES;
}

#pragma mark Special Deals
-(void)onBuy50000:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature50000];
    buyClicked = YES;
}

-(void)onBuy200000:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature200000];
    buyClicked = YES;
}

-(void)onBuy1000000:(id)sender
{
    if (buyClicked) {
        return;
    }
    [[MKStoreManager sharedManager]buyFeature1000000];
    buyClicked = YES;
}

-(void)onBack:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[Items node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

#pragma mark Timer

-(void)onTimer:(CCTime)dt
{
    long gold = [u integerForKey:@"Gold"];
    [ coinLabel setString:[NSString stringWithFormat:@"GOLD: %ld",gold]];
}

// -----------------------------------------------------------------------
@end
