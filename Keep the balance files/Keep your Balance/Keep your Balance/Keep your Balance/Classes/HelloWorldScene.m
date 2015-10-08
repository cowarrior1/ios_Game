//
//  HelloWorldScene.m
//  Keep your Balance
//
//  Created by XianDe on 6/11/14.
//  Copyright Golden 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    NSUserDefaults *u;
    
    float speed;
    
    CCLabelTTF *scorelabel;
    CCLabelTTF *goldlabel;
    
    CCLabelTTF *slowlabel;
    CCLabelTTF *dontlabel;
    CCLabelTTF *flylabel;
    
    CCLabelTTF *startlabel;
    
    CCButton *saveBt1;
    CCButton *saveBt2;
    CCButton *tryBt;
    
    int score;
    int gold;
    
    int now[3];
    
    CCSprite *pathSp[7];
    CCSprite *hero_sp;
    
    CGPoint m_bPoint;
    
    float m_scaleX;
    float m_scaleY;
    
    NSMutableArray *shapes[7];
    
    BOOL isOver;
    BOOL isStart;
    BOOL isJump;
    BOOL isPause;
    
    BOOL isDontDie;
    BOOL isFly;
    BOOL isSlow;
    BOOL isDouble;
    
    int slowtime;
    int flytime;
    int donttime;
    
    CCPhysicsNode *physicsWorld;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    u = [NSUserDefaults standardUserDefaults];
    
    [self setImageScale];
    // Create a colored background (Dark Grey)
//    CCSprite *background = [CCSprite spriteWithImageNamed:@"play_bg.png"];
//    background.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
//    [self addChild:background];
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [self addChild:background];
    
    CCSprite *headersp = [CCSprite spriteWithImageNamed:@"play_header.png"];
    headersp.scaleX = 0.5f; headersp.scaleY = 0.5f;
    headersp.position = ccp(self.contentSize.width/2.0f, self.contentSize.height-headersp.contentSize.height*headersp.scaleY/2.0f);
    [self addChild:headersp z:2];
    
    score = 0;
    scorelabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana-Bold" fontSize:48.0f*m_scaleX];
    scorelabel.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.85f);
    scorelabel.color = [CCColor orangeColor];
    [self addChild:scorelabel z:2];
    
    gold = (int)[u integerForKey:@"Gold"];
    goldlabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Gold: %d",gold] fontName:@"Verdana-Bold" fontSize:48.0f*m_scaleX];
    goldlabel.position = ccp(self.contentSize.width*0.8f, self.contentSize.height*0.85f);
    goldlabel.color = [CCColor orangeColor];
    [self addChild:goldlabel z:2];
    
    //Create Background
    CCButton *pauseBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause_bt.png"]];
    pauseBt.scaleX = m_scaleX*2.0f; pauseBt.scaleY = m_scaleY*2.0f;
    pauseBt.position = ccp(self.contentSize.width*0.07f, self.contentSize.height*0.95f);
    [pauseBt setTarget:self selector:@selector(onPause:)];
    [self addChild:pauseBt z:2];
    
    CCButton *slowBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"slowmotion_bt.png"]];
    slowBt.scaleX = m_scaleX*2.0f; slowBt.scaleY = m_scaleY*2.0f;
    slowBt.position = ccp(self.contentSize.width*0.32f, self.contentSize.height*0.95f);
    [slowBt setTarget:self selector:@selector(onSlow:)];
    if ([u integerForKey:@"SlowMotion"]<=0) {
        slowBt.visible = false;
        slowBt.enabled = NO;
    }
    [self addChild:slowBt z:2];
    
    CCButton *dontBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"dont_bt.png"]];
    dontBt.scaleX = m_scaleX*2.0f; dontBt.scaleY = m_scaleY*2.0f;
    dontBt.position = ccp(self.contentSize.width*0.64f, self.contentSize.height*0.95f);
    [dontBt setTarget:self selector:@selector(onDont:)];
    if ([u integerForKey:@"DontDie"]<=0) {
        dontBt.visible = NO;
        dontBt.enabled = NO;
    }
    [self addChild:dontBt z:2];
    
    CCButton *flyBt = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"fly_bt.png"]];
    flyBt.scaleX = m_scaleX*2.0f; flyBt.scaleY = m_scaleY*2.0f;
    flyBt.position = ccp(self.contentSize.width*0.87f, self.contentSize.height*0.95f);
    [flyBt setTarget:self selector:@selector(onFly:)];
    if ([u integerForKey:@"Fly"]<=0) {
        flyBt.visible = NO;
        flyBt.enabled = NO;
    }
    [self addChild:flyBt z:2];
    
    startlabel = [CCLabelTTF labelWithString:@"You can jump by drag up!" fontName:@"Verdana-Bold" fontSize:48.0f*m_scaleX];
    startlabel.color = [CCColor redColor];
    startlabel.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:startlabel z:2];
    
    if ([u integerForKey:@"SaveMe"]>=1) {
        
        saveBt1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"save_me_10000.png"]];
        saveBt1.scaleX = m_scaleX*2.0f; saveBt1.scaleY = m_scaleY*2.0f;
        saveBt1.position = ccp(self.contentSize.width*0.2f, self.contentSize.height*0.1f);
        [saveBt1 setTarget:self selector:@selector(onSaveMe1)];
        [self addChild:saveBt1 z:2];
        
    }
    
    if ([u integerForKey:@"SaveMe2"]>=1) {
    
        saveBt2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"save_me_50000.png"]];
        saveBt2.scaleX = m_scaleX*2.0f; saveBt2.scaleY = m_scaleY*2.0f;
        saveBt2.position = ccp(self.contentSize.width*0.8f, self.contentSize.height*0.1f);
        [saveBt2 setTarget:self selector:@selector(onSaveMe2)];
        [self addChild:saveBt2 z:2];
        
    }
    // Create a back button
    [self createPhsycis];
    
    [self setPoints];
    
    [self setPath];
    
    [self setHero];

    [self setLabel];
    
    speed = 0.7f;
    
    
    
    [self schedule:@selector(onTimer:) interval:0.01f];
    // done
	return self;
}

-(void)createPhsycis
{
    physicsWorld = [CCPhysicsNode node];
    physicsWorld.gravity = ccp(0.0f, 0.0f);
    physicsWorld.debugDraw = NO;
    physicsWorld.collisionDelegate = self;
    [self addChild:physicsWorld];
}

-(void)setLabel
{
    slowlabel = [CCLabelTTF labelWithString:@"Left:" fontName:@"Verdana-Bold" fontSize:36.0f*m_scaleX];
    slowlabel.position = ccp(self.contentSize.width*0.32f, self.contentSize.height*0.92f);
    slowlabel.visible = NO;
    [self addChild:slowlabel z:2];
    
    dontlabel = [CCLabelTTF labelWithString:@"Left:" fontName:@"Verdana-Bold" fontSize:36.0f*m_scaleX];
    dontlabel.position = ccp(self.contentSize.width*0.64f, self.contentSize.height*0.92);
    dontlabel.visible = NO;
    [self addChild:dontlabel z:2];
    
    flylabel = [CCLabelTTF labelWithString:@"Left:" fontName:@"Verdana-Bold" fontSize:36.0f*m_scaleX];
    flylabel.position = ccp(self.contentSize.width*0.87f, self.contentSize.height*0.92f);
    flylabel.visible = NO;
    [self addChild:flylabel z:2];
}

-(void)setImageScale
{
    m_scaleX = self.contentSize.width/640.0f/2.0f;
    m_scaleY = self.contentSize.height/1024.0f/2.0f;
}

-(void)setPoints
{
    CGPoint po[100];
    CCPhysicsShape *shape;
    shapes[0] = [[NSMutableArray alloc]init];
    po[0] = ccp(0.0f, 640-476.0f);
    po[1] = ccp(188.0f, 640-391.0f);
    po[2] = ccp(188.f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[0] addObject:shape];
    
    po[0] = ccp(188.0f, 640-391.0f);
    po[1] = ccp(250.0f, 640-391.0f);
    po[2] = ccp(250.0f, 640.0f);
    po[3] = ccp(188.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[0] addObject:shape];
    
    po[0] = ccp(388.0f, 640-391.0f);
    po[1] = ccp(446.0f, 640-391.0f);
    po[2] = ccp(446.0f, 640.0f);
    po[3] = ccp(388.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[0] addObject:shape];
    
    po[0] = ccp(446.0f, 640-391.0f);
    po[1] = ccp(640.0f, 640-470.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(446.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[0] addObject:shape];
    
    po[0] = ccp(250.0f, 640-65.0f);
    po[1] = ccp(388.0f, 640-65.0f);
    po[2] = ccp(388.0f, 640.0f);
    po[3] = ccp(250.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[0] addObject:shape];

    shapes[1] = [[NSMutableArray alloc]init];
    
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(169.0f, 0.0f);
    po[2] = ccp(169.0f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[1] addObject:shape];
    
    po[0] = ccp(169.0f, 640-109.0f);
    po[1] = ccp(305.0f, 640-109.0f);
    po[2] = ccp(305.0f, 640.0f);
    po[3] = ccp(169.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[1] addObject:shape];
    
    po[0] = ccp(305.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(305.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[1] addObject:shape];

    
    shapes[2] = [[NSMutableArray alloc]init];
    
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(331.0f, 0.0f);
    po[2] = ccp(331.0f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[2] addObject:shape];
    
    po[3] = ccp(331.0f, 640-109.0f);
    po[2] = ccp(469.0f, 640-109.0f);
    po[1] = ccp(469.0f, 640.0f);
    po[0] = ccp(331.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[2] addObject:shape];
    
    po[0] = ccp(469.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(469.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[2] addObject:shape];
    
    
    
    shapes[3] = [[NSMutableArray alloc]init];
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(331.0f, 0.0f);
    po[2] = ccp(331.0f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[3] addObject:shape];
    
    po[0] = ccp(331.0f,640-377.0f);
    po[1] = ccp(469.0f, 640-377.0f);
    po[2] = ccp(469.0f, 640-314.0f);
    po[3] = ccp(331.0f, 640-314.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[3] addObject:shape];
    
    po[0] = ccp(331.0f, 640-47.0f);
    po[1] = ccp(469.0f, 640-47.0f);
    po[2] = ccp(469.0f, 640.0f);
    po[3] = ccp(331.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[3] addObject:shape];
    
    po[0] = ccp(469.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(469.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[3] addObject:shape];
    
    
    
    shapes[4] = [[NSMutableArray alloc]init];
    
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(169.0f, 0.0f);
    po[2] = ccp(169.0f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[4] addObject:shape];
    
    po[0] = ccp(169.0f, 640-377.0f);
    po[1] = ccp(304.0f, 640-377.0f);
    po[2] = ccp(304.0f, 640-313.0f);
    po[3] = ccp(169.0f, 640-313.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[4] addObject:shape];
    
    po[0] = ccp(169.0f, 640-47.0f);
    po[1] = ccp(304.0f, 640-47.0f);
    po[2] = ccp(304.0f, 640.0f);
    po[3] = ccp(169.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[4] addObject:shape];
    
    po[0] = ccp(304.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(304.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[4] addObject:shape];
    
    
    
    shapes[5] = [[NSMutableArray alloc]init];
    
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(331.0f, 0.0f);
    po[2] = ccp(331.0f, 640-382.0f);
    po[3] = ccp(169.0f, 640-212.0f);
    po[4] = ccp(0.0f, 640-212.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:5 cornerRadius:0.0f];
    [shapes[5] addObject:shape];
    
    po[0] = ccp(0.0f, 640-212.0f);
    po[1] = ccp(169.0f, 640-212.0f);
    po[2] = ccp(169.0f, 640.0f);
    po[3] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[5] addObject:shape];
    
    po[0] = ccp(469.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640-382.0f);
    po[3] = ccp(469.0f, 640-382.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[5] addObject:shape];
    
    po[0] = ccp(469.0f, 640-382.0f);
    po[1] = ccp(640.0f, 640-382.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(307.0f, 640.0f);
    po[4] = ccp(307.0f, 640.0f-212.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:5 cornerRadius:0.0f];
    [shapes[5] addObject:shape];
    
    
    
    shapes[6] = [[NSMutableArray alloc]init];
    
    po[0] = ccp(0.0f, 0.0f);
    po[1] = ccp(169.0f, 0.0f);
    po[2] = ccp(169.0f, 640-425.0f);
    po[3] = ccp(0.0f, 640-425.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[6] addObject:shape];
    
    po[0] = ccp(0.0f, 640-425.0f);
    po[1] = ccp(169.0f, 640-425.0f);
    po[2] = ccp(325.0f, 640-253.0f);
    po[3] = ccp(325.0f, 640.0f);
    po[4] = ccp(0.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:5 cornerRadius:0.0f];
    [shapes[6] addObject:shape];
    
    po[0] = ccp(301.0f, 0.0f);
    po[1] = ccp(640.0f, 0.0f);
    po[2] = ccp(640.0f, 640-253.0f);
    po[3] = ccp(457.0f, 640-253.0f);
    po[4] = ccp(301.0f, 640-425.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:5 cornerRadius:0.0f];
    [shapes[6] addObject:shape];
    
    po[0] = ccp(457.0f, 640-253.0f);
    po[1] = ccp(640.0f, 640-253.0f);
    po[2] = ccp(640.0f, 640.0f);
    po[3] = ccp(457.0f, 640.0f);
    shape = [CCPhysicsShape polygonShapeWithPoints:po count:4 cornerRadius:0.0f];
    [shapes[6] addObject:shape];
    
    
}

-(void)setPath
{
    for (int i=0; i<7; i++) {
        pathSp[i] = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"track%d.png",i+1]];
        pathSp[i].scaleX = m_scaleX*2.0f; pathSp[i].scaleY = m_scaleY*2.0f;
        
        pathSp[i].position = ccp(self.contentSize.width/2.0f, -self.contentSize.height);
        pathSp[i].physicsBody = [CCPhysicsBody bodyWithShapes:shapes[i]];
        
        pathSp[i].physicsBody.collisionGroup = @"PathGroup";
        pathSp[i].physicsBody.collisionType = @"PathItem";
        [physicsWorld addChild:pathSp[i]];
    }
    
    now[0] = 0;
    now[1] = arc4random()%6+1;
    now[2] = arc4random()%6+1;
    if (now[2] == now[1]) {
        now[2] ++;
        if (now[2] == 7) {
            now[2] = 5;
        }
    }
    
    NSLog(@"Now=%d,%d,%d",now[0],now[1],now[2]);
    
    for (int i=0; i<3; i++) {
        if (i == 0) {
            pathSp[now[i]].position = ccp(self.contentSize.width/2.0f, pathSp[0].contentSize.height*pathSp[0].scaleY/2.0f*(i*2+1));
        }
        else
        {
            pathSp[now[i]].position = ccp(self.contentSize.width/2.0f, pathSp[now[i-1]].contentSize.height*pathSp[now[i-1]].scaleY/2.0f+pathSp[now[i-1]].position.y + pathSp[now[i]].contentSize.height*pathSp[now[i]].scaleY/2.0f);
        }
    }
}

-(void)setHero
{
    hero_sp = [CCSprite spriteWithImageNamed:@"ball.png"];
    hero_sp.scaleX = m_scaleX*2.0f; hero_sp.scaleY = m_scaleY*2.0f;
    hero_sp.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.25f);

    hero_sp.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:hero_sp.contentSize.width*hero_sp.scaleX/2.0f andCenter:hero_sp.anchorPointInPoints];
    hero_sp.physicsBody.collisionGroup = @"HeroGroup";
    hero_sp.physicsBody.collisionType = @"HeroItem";
    [physicsWorld addChild:hero_sp];
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isStart == NO) {
        isStart = YES;
        saveBt1.visible = NO;
        saveBt2.visible = NO;
        startlabel.visible = NO;
    }
    
    if (isDouble == YES && isJump == NO && isFly == NO) {
        isJump = YES;
        isDouble = NO;
        [self makeJump];
    }
    else
        isDouble = YES;
    
    CGPoint touchLoc = [touch locationInNode:self];
    m_bPoint = touchLoc;
    // Log touch location
//    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    [self colorWithPoint:touchLoc];
}

-(BOOL)colorWithPoint:(CGPoint)loc { //This is the pixel we will read and test UInt8 pixelColors[4];
    
    UInt8 pixelColors[4];
    //Prepare a render texture to draw the receiver on, so you are able to read the required pixel and test
    CCRenderTexture* renderTexture = [[CCRenderTexture alloc] initWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:CCTexturePixelFormat_RGBA8888];
    
    [renderTexture begin];
    [pathSp[0] draw];
    
    glReadPixels((GLint)loc.x,(GLint)loc.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &pixelColors[0]);
    
    [renderTexture end];
    
    NSLog(@"pixel color: %u, %u, %u, %u", pixelColors[0], pixelColors[1], pixelColors[2],pixelColors[3]);
    return YES;
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];
    if (isOver || isStart == NO || isPause == YES) {
        return;
    }
    
    if ((abs(m_bPoint.y-touchLoc.y)>(self.contentSize.width/20.0f) || abs(m_bPoint.x-touchLoc.x)>(self.contentSize.width/20.0f)) && isJump == NO && isFly ==NO) {
        isJump = YES;
        [self makeJump];
    }
    
    hero_sp.position = ccp(hero_sp.position.x-m_bPoint.x+touchLoc.x, hero_sp.position.y-m_bPoint.y+touchLoc.y);
    
    if (hero_sp.position.x<(hero_sp.contentSize.width*hero_sp.scaleX/2.0f)) {
        hero_sp.position = ccp(hero_sp.contentSize.width*hero_sp.scaleX*0.5f, hero_sp.position.y) ;
    }
    else if(hero_sp.position.x>(self.contentSize.width-hero_sp.contentSize.width*hero_sp.scaleX/2.0f))
    {
        hero_sp.position = ccp(self.contentSize.width-hero_sp.contentSize.width*hero_sp.scaleX/2.0f, hero_sp.position.y);
    }
    
    if (hero_sp.position.y<(hero_sp.contentSize.height*hero_sp.scaleY*0.5f)) {
        hero_sp.position = ccp(hero_sp.position.x, hero_sp.contentSize.height*hero_sp.scaleY*0.5f);
    }
    else if(hero_sp.position.y>(self.contentSize.height-hero_sp.contentSize.height*hero_sp.scaleY*0.5f))
    {
        hero_sp.position = ccp(hero_sp.position.y, self.contentSize.height-hero_sp.contentSize.height*hero_sp.scaleY*0.5f);
    }
    m_bPoint = touchLoc;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

-(void)makeJump
{
    [[OALSimpleAudio sharedInstance]playEffect:@"Jump.mp3"];
    
    CCAction *action1 = [CCActionScaleBy actionWithDuration:0.1f scale:2.0f];
    CCActionScaleBy *action2 = [CCActionScaleBy actionWithDuration:0.2f scale:0.5f];
    CCActionCallFunc *action3 = [CCActionCallFunc actionWithTarget:self selector:@selector(hideJump)];
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[action1,delay,action2,action3]];
    [hero_sp runAction:seq];
}

-(void)hideJump
{
    isJump = NO;
}

-(void)onTimer:(CCTime)dt
{
    if (isStart == NO || isPause == YES) {
        return;
    }
    
    for (int i=0; i<3; i++) {
        pathSp[now[i]].position = ccp(pathSp[now[i]].position.x, pathSp[now[i]].position.y-speed);
        if (pathSp[now[i]].position.y<-pathSp[now[i]].contentSize.height*pathSp[now[i]].scaleY*0.5f) {
            [self changePath:i];
//            pathSp[i].position = ccp(pathSp[i].position.x, pathSp[i].contentSize.height*pathSp[i].scaleY*2.5f-0.5f);
        }
    }
//    [self compHero];
//    [self compareHero];
    [self addPoints];
    static float tt=0.0f;
    
    if (isDouble == YES) {
        tt+=dt;
        if (tt>0.5f) {
            tt = 0.0f;
            isDouble = NO;
        }
    }
    
    if (hero_sp.position.x<(hero_sp.contentSize.width*hero_sp.scaleX/2.0f)) {
        hero_sp.position = ccp(hero_sp.contentSize.width*hero_sp.scaleX*0.5f, hero_sp.position.y) ;
    }
    else if(hero_sp.position.x>(self.contentSize.width-hero_sp.contentSize.width*hero_sp.scaleX/2.0f))
    {
        hero_sp.position = ccp(self.contentSize.width-hero_sp.contentSize.width*hero_sp.scaleX/2.0f, hero_sp.position.y);
    }
    
    if (hero_sp.position.y<(hero_sp.contentSize.height*hero_sp.scaleY*0.5f)) {
        hero_sp.position = ccp(hero_sp.position.x, hero_sp.contentSize.height*hero_sp.scaleY*0.5f);
    }
    else if(hero_sp.position.y>(self.contentSize.height-hero_sp.contentSize.height*hero_sp.scaleY*0.5f))
    {
        hero_sp.position = ccp(hero_sp.position.y, self.contentSize.height-hero_sp.contentSize.height*hero_sp.scaleY*0.5f);
    }
}


-(void)compareHero
{
    if (isFly == YES || isJump == YES || isDontDie == YES || isOver == YES) {
        return;
    }
    int j;
    for (int i = 0; i < 3; i++) {
        j = now[i];
        if (j == 6) {
            if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+20.0f, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-40.0f, 280.0f, 80.0f), hero_sp.position))
            {
                return;
            }
        }
        else if(j == 3)
        {
            if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+200.0f, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-20.0f, 80.0f, 280.0f), hero_sp.position))
            {
                return;
            }
        }
        else if(j == 2)
        {
            if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+115.0f, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-25.0f, 80.0f, 280.0f), hero_sp.position))
            {
                return;
            }
        }
        else if(j == 1)
        {
            if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+75.0f, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-20.0f, 80.0f, 280.0f), hero_sp.position))
            {
                return;
            }
        }
        else if(j == 0)
        {
            for (int k = 0; k<640; k++) {
                if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+95.0f-0.6f*k, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-k, 130.0f+1.2f*k, 1.0f), hero_sp.position))
                {
                    return;
                }
            }
        }
        else if(j == 4)
        {
            for (int k = 30; k<290; k++) {
                if (k<85) {
                    if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+105.0f-1.0f*k, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-k, 1.0f+2.0f*k, 1.0f), hero_sp.position))
                    {
                        return;
                    }
                }
                else if(k>205)
                {
                    if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+40.0f+2.08f*k, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-k, 110.0f, 1.0f), hero_sp.position))
                    {
                        return;
                    }
                }
                else
                {
                    if(CGRectContainsPoint(CGRectMake(pathSp[j].position.x-pathSp[j].contentSize.width*pathSp[j].scale*0.5f+178.0f+1.0f*k, pathSp[j].position.y+pathSp[j].contentSize.height*pathSp[j].scale*0.5f-k, 110.0f-2.0f*k, 1.0f), hero_sp.position))
                    {
                        return;
                    }
                }
            }
        }
        else if(j == 5)
        {
            
        }
    }
    [self GameOver];
}

-(void)compHero
{
    if (hero_sp.position.x<self.contentSize.width/4.0f || hero_sp.position.x>self.contentSize.width*3/4) {
        [self GameOver];
    }
}

-(void)addGold
{
    [[OALSimpleAudio sharedInstance]playEffect:@"Coin.mp3"];
    [goldlabel setString:[NSString stringWithFormat:@"Gold: %d",gold]];
    [u setInteger:gold forKey:@"Gold"];
    [u synchronize];
}

-(void)addPoints
{
    if ((int)(score/1000) != (int)((score+speed*10/5)/1000)) {
        if(score>=7000)
        {
            gold+=75;
        }
        else
            gold+=50;
        speed+=0.2f;
        [self addGold];
    }
    if (score<5000 && (score+speed*10/5)>=5000) {
        speed += 0.3f;
    }
    else if(score<10000 && (score+speed*10/5)>=10000)
    {
        speed += 0.3f;
    }
    else if(score<7000 && (score+speed*10/5)>=7000)
    {
        speed += 0.3f;
    }
//    if (speed>1.3f) {
//        speed = 1.3f;
//    }
    
    score += speed*10/5;
    [scorelabel setString:[NSString stringWithFormat:@"Score: %d",score]];
}

-(void)changePath:(int)sender
{
    int comp1;
    int comp2;
    if (sender == 0) {
        comp1 = now[1];
        comp2 = now[2];
    }
    else if(sender == 1)
    {
        comp1 = now[2];
        comp2 = now[0];
    }
    else
    {
        comp2 = now[1];
        comp1 = now[0];
    }
    int ran = arc4random()%6+1;
    while (ran == comp1 || ran == comp2) {
        ran = arc4random()%6+1;
    }
    
    now[sender] = ran;
    pathSp[ran].position = ccp(self.contentSize.width/2.0f, pathSp[comp2].contentSize.height*pathSp[comp2].scaleY/2.0f+pathSp[comp2].position.y + pathSp[ran].contentSize.height*pathSp[ran].scaleY/2.0f-speed);
}

#pragma makr Game Over

-(void)GameOver
{
    isOver = YES;
    [self unschedule:@selector(onTimer:)];
    CCSprite *sp = [CCSprite spriteWithImageNamed:@"over_bg.png"];
    sp.scaleX = m_scaleX*2.0f; sp.scaleY = m_scaleY*2.0f;
    sp.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:sp z:3 name:@"Over1"];
    
    CCLabelTTF *overLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Verdana-Bold" fontSize:102.0f*m_scaleX];
    overLabel.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.7f);
    [self addChild:overLabel z:3 name:@"Over2"];
    
    CCLabelTTF *currentScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d",score] fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    currentScore.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.55f);
    [self addChild:currentScore z:3 name:@"Over3"];
    
    long high;
    
    high = [u integerForKey:@"HighScore"];
    if (high<score) {
        high = score;
        [u setInteger:high forKey:@"HighScore"];
        [u synchronize];
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app submitHighScore];
    }
    
    CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %ld",high] fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    highScore.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.5f);
    [self addChild:highScore z:3 name:@"Over4"];
    
    CCButton *replayBt = [CCButton buttonWithTitle:@"Replay" fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    replayBt.position = ccp(self.contentSize.width*0.3f, self.contentSize.height*0.3f);
    [replayBt setTarget:self selector:@selector(onReplay:)];
    [self addChild:replayBt z:3 name:@"Over5"];
    
    CCButton *menuBt = [CCButton buttonWithTitle:@"Menu" fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    menuBt.position = ccp(self.contentSize.width*0.7f, self.contentSize.height*0.3f);
    [menuBt setTarget:self selector:@selector(onMenu:)];
    [self addChild:menuBt z:3 name:@"Over6"];
    
    if ([u integerForKey:@"Try"] >= 1) {
        tryBt = [CCButton buttonWithTitle:@"Try!" fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
        tryBt.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.3f);
        [tryBt setTarget:self selector:@selector(onTry:)];
        [self addChild:tryBt z:3];
    }
}

#pragma mark Button Events

-(void)onReplay:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[HelloWorldScene node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onMenu:(id)sender
{
    [[CCDirector sharedDirector]replaceScene:[IntroScene node] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)onPause:(id)sender
{
    if (isOver) {
        return;
    }
    
    isPause = YES;
    
    CCSprite *sp = [CCSprite spriteWithImageNamed:@"over_bg.png"];
    sp.scaleX = m_scaleX*2.0f; sp.scaleY = m_scaleY*2.0f;
    sp.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
    [self addChild:sp z:3 name:@"pauseBG"];
    
    CCLabelTTF *overLabel = [CCLabelTTF labelWithString:@"Paused" fontName:@"Verdana-Bold" fontSize:102.0f*m_scaleX];
    overLabel.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*0.7f);
    [self addChild:overLabel z:3 name:@"pauseLABEL"];
    
    CCButton *replayBt = [CCButton buttonWithTitle:@"Resume" fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    replayBt.position = ccp(self.contentSize.width*0.35f, self.contentSize.height*0.3f);
    [replayBt setTarget:self selector:@selector(onResume:)];
    [self addChild:replayBt z:3 name:@"resumeBT"];
    
    CCButton *menuBt = [CCButton buttonWithTitle:@"Menu" fontName:@"Verdana-Bold" fontSize:60.0f*m_scaleX];
    menuBt.position = ccp(self.contentSize.width*0.65f, self.contentSize.height*0.3f);
    [menuBt setTarget:self selector:@selector(onMenu:)];
    [self addChild:menuBt z:3 name:@"menuBT"];
    
}

-(void)onResume:(id)sender
{
    [self hidePause];
    isPause = NO;
}

-(void)hidePause
{
    id a = [self getChildByName:@"pauseBG" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"resumeBT" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"menuBT" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"pauseLABEL" recursively:NO];
    [a removeFromParentAndCleanup:YES];
}

-(void)onSlow:(id)sender
{
    if (isSlow == YES) {
        return;
    }
    long slow;
    slow = [u integerForKey:@"SlowMotion"];
    slow --;
    [u setInteger:slow forKey:@"SlowMotion"];
    [u synchronize];
    if (slow<=0) {
        [sender setVisible:NO];
        [sender setEnabled:NO];
    }
    
    slowlabel.visible = YES;
    slowtime = 10;
    [self playEffectSound];
    [self schedule:@selector(setSlow:) interval:1.0f];
    
    speed = speed/2.0f;
    CCActionDelay *delay = [CCActionDelay actionWithDuration:10.0f];
    CCActionCallFunc *action = [CCActionCallFunc actionWithTarget:self selector:@selector(makeSlow)];
    
    [sender runAction:[CCActionSequence actionWithArray:@[delay,action]]];
}

-(void)setSlow:(CCTime)dt
{
    
    
    if (slowtime<0) {
        [self unschedule:@selector(setSlow:)];
        slowlabel.visible = NO;
    }
    
    [slowlabel setString:[NSString stringWithFormat:@"Left: %d",slowtime]];
    slowtime--;
}

-(void)makeSlow
{
    speed = speed*2.0f;
}

-(void)onDont:(id)sender
{
    if (isDontDie == YES) {
        return;
    }
    long dont;
    dont = [u integerForKey:@"DontDie"];
    dont --;
    [u setInteger:dont forKey:@"DontDie"];
    [u synchronize];
    if (dont<=0) {
        [sender setVisible:NO];
        [sender setEnabled:NO];
    }
    
    dontlabel.visible = YES;
    donttime = 10;
    [self playEffectSound];
    [self schedule:@selector(setDont:) interval:1.0f];
    
    isDontDie = YES;
    CCActionDelay *delay = [CCActionDelay actionWithDuration:10.0f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(makeDont)];
    [self runAction:[CCActionSequence actionWithArray:@[delay,func]]];
}

-(void)setDont:(CCTime)dt
{
    
    
    if (donttime<0) {
        [self unschedule:@selector(setDont:)];
        dontlabel.visible = NO;
    }
    
    [dontlabel setString:[NSString stringWithFormat:@"Left: %d",donttime]];
    donttime--;
}

-(void)makeDont
{
    isDontDie = NO;
}

-(void)onFly:(id)sender
{
    if (isFly == YES) {
        return;
    }
    long slow;
    slow = [u integerForKey:@"Fly"];
    slow --;
    [u setInteger:slow forKey:@"Fly"];
    [u synchronize];
    if (slow<=0) {
        [sender setVisible:NO];
        [sender setEnabled:NO];
    }
    
    flylabel.visible = YES;
    flytime = 10;
    [self playEffectSound];
    [self schedule:@selector(setFly:) interval:1.0f];
    
    isFly = YES;
    CCActionScaleBy *action1 = [CCActionScaleBy actionWithDuration:0.5f scale:2.0f];
    CCActionDelay *actiondelay = [CCActionDelay actionWithDuration:9.0f];
    CCActionScaleBy *action2 = [CCActionScaleBy actionWithDuration:0.5f scale:0.5f];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[action1,actiondelay,action2]];
    [hero_sp runAction:seq];
    
    CCActionDelay *delay = [CCActionDelay actionWithDuration:10.0f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(makeFly)];
    [self runAction:[CCActionSequence actionWithArray:@[delay,func]]];
}

-(void)setFly:(CCTime)dt
{
    
    
    if (flytime<0) {
        [self unschedule:@selector(setFly:)];
        flylabel.visible = NO;
    }
    
    [flylabel setString:[NSString stringWithFormat:@"Left: %d",flytime]];
    
    flytime --;
}

-(void)makeFly
{
    isFly = NO;
}

-(void)onSaveMe1
{
    [self playEffectSound];
    score = 10000;
    isStart = YES;
    startlabel.visible = NO;
    saveBt1.visible = NO;
    saveBt2.visible = NO;
}

-(void)onSaveMe2
{
    [self playEffectSound];
    score = 50000;
    isStart = YES;
    startlabel.visible = NO;
    saveBt1.visible = NO;
    saveBt2.visible = NO;
}

-(void)onTry:(id)sender
{
    [u setInteger:([u integerForKey:@"Try"] - 1) forKey:@"Try"];
    [u synchronize];
    
    [tryBt removeFromParentAndCleanup:YES];
    id a = [self getChildByName:@"Over1" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"Over2" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"Over3" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"Over4" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"Over5" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    a = [self getChildByName:@"Over6" recursively:NO];
    [a removeFromParentAndCleanup:YES];
    
    isOver = NO;
    
    flylabel.visible = YES;
    flytime = 10;
    [self schedule:@selector(setFly:) interval:1.0f];
    
    isFly = YES;
    
     [self schedule:@selector(onTimer:) interval:0.01f];
    CCActionScaleBy *action1 = [CCActionScaleBy actionWithDuration:0.5f scale:2.0f];
    CCActionDelay *actiondelay = [CCActionDelay actionWithDuration:9.0f];
    CCActionScaleBy *action2 = [CCActionScaleBy actionWithDuration:0.5f scale:0.5f];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[action1,actiondelay,action2]];
    [hero_sp runAction:seq];
    
    CCActionDelay *delay = [CCActionDelay actionWithDuration:10.0f];
    CCActionCallFunc *func = [CCActionCallFunc actionWithTarget:self selector:@selector(makeFly)];
    [self runAction:[CCActionSequence actionWithArray:@[delay,func]]];
    
   
}

-(void)playEffectSound
{
    [[OALSimpleAudio sharedInstance]playEffect:@"Power_Up.mp3"];
}

#pragma mark Collision Test

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair HeroItem:(CCNode *)hero PathItem:(CCNode *)path
{
    NSLog(@"Touched");
    if (isJump == NO && isDontDie == NO && isFly == NO && isOver == NO) {
        [self GameOver];
    }
    
    return NO;
}
// -----------------------------------------------------------------------
@end
