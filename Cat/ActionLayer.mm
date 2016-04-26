//
//  ActionLayer.mm
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "ActionLayer.h"
#import "IntroLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


#pragma mark - ActionLayer

@interface ActionLayer()
//-(void) checkCandyPick;
@end

@implementation ActionLayer

ActionLayer* instanceOfGameScene;

+(ActionLayer*) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}

-(NSMutableArray*)sharedGravitySourceStack
{
    return gravitySourceStack;
}



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ActionLayer *layer = [ActionLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		// enable events
		instanceOfGameScene = self;
		self.isTouchEnabled = YES;
		//self.isAccelerometerEnabled = YES;
        [self initPhysics];
        [self initLightSourceStack];
        [self initCandyStack];
		//CGSize s = [CCDirector sharedDirector].winSize;
        
        CCMenuItemLabel *menuLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"RESTART"fontName:@"Helvetica Neue"fontSize:18] target:self selector:@selector(restart)];
        CCMenu *menu = [CCMenu menuWithItems:menuLabel, nil];
        CGSize screen = [[CCDirector sharedDirector] winSize];
        menu.position = ccp(screen.width-80, screen.height-50);
        [self addChild:menu z:4];
        
        /*
        Butterfly *butterfly = [Butterfly initButterfly:@"Icon-Small-50.png" atPosition:ccp(400, 400) world:world layer:self];
        [self addChild:butterfly];
         */
        
        Cat *cat = [Cat initCat:ccp(400,400) world:world layer:self];
        [self addChild:cat];
        
		[self scheduleUpdate];
	}
	return self;
}



-(void) initLightSourceStack
{

    gravitySourceStack = [[NSMutableArray alloc] init];
    
    GravitySource *lighter1 = [GravitySource initGravitySource:@"blocks.png" atPosition:ccp(500, 350) world:world layer:self];
    [self addChild:lighter1];
    
    GravitySource *lighter2 = [GravitySource initGravitySource:@"blocks.png" atPosition:ccp(800, 100) world:world layer:self];
    [self addChild:lighter2];
    
    GravitySource *lighter3 = [GravitySource initGravitySource:@"blocks.png" atPosition:ccp(800, 600) world:world layer:self];
    [self addChild:lighter3];
    
    GravitySource *lighter4 = [GravitySource initGravitySource:@"blocks.png" atPosition:ccp(100, 350) world:world layer:self];
    [self addChild:lighter4];
    
    [gravitySourceStack addObject:lighter1];
    [gravitySourceStack addObject:lighter2];
    [gravitySourceStack addObject:lighter3];
    [gravitySourceStack addObject:lighter4];

    /*
    CGPoint positions [] =
    {
         CGPointMake(100, 100),
         CGPointMake(500, 100),
         CGPointMake(300, 100)
    };
    
    
    LightSourceChain* lightChain = [LightSourceChain initLightSourceChain:@"Icon-72.png" count:3 atPosition:positions world:world layer:self];
    [self addChild:lightChain];
    [lightChain addLightsInLightSourceStack:lightSourceStack];
     
     */
}

-(void) initCandyStack
{
    /*
    //candyStack = [[NSMutableArray alloc] init];
    Candy *candy1 = [Candy initCandy:@"Candy.png" atPosition:ccp(600, 450) world:world layer:self];
    [self addChild:candy1];
    Candy *candy2 = [Candy initCandy:@"Candy.png" atPosition:ccp(400, 450) world:world layer:self];
    [self addChild:candy2];
    Candy *candy3 = [Candy initCandy:@"Candy.png" atPosition:ccp(400, 250) world:world layer:self];
    [self addChild:candy3];
    Candy *candy4 = [Candy initCandy:@"Candy.png" atPosition:ccp(600, 250) world:world layer:self];
    [self addChild:candy4];
    Candy *candy5 = [Candy initCandy:@"Candy.png" atPosition:ccp(900, 350) world:world layer:self];
    [self addChild:candy5];
    Candy *candy6 = [Candy initCandy:@"Candy.png" atPosition:ccp(200, 200) world:world layer:self];
    [self addChild:candy6];
    Candy *candy7 = [Candy initCandy:@"Candy.png" atPosition:ccp(100, 700) world:world layer:self];
    [self addChild:candy7];
     */
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    /*
    ContactListener* contactListener = new ContactListener();
    world->SetContactListener(contactListener);
     */
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	/*
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
     */
}


-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
       // CCLOG(@"%f",location.x);
       // CCLOG(@"%f",location.y);
        for (GravitySource* light in gravitySourceStack)
        {

            if (CGRectContainsPoint(light.spriteRect, location))
            {
                if (light.state == OFF)
                {
                //light.sprite.color = ccMAGENTA;
                light.state = ON;
                }
                else
                {
                  //  light.sprite.color = ccWHITE;
                    light.state = OFF;
                }
            }

        }
    }
}


-(void)restart
{
   	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ActionLayer scene] withColor:ccWHITE]];
}

-(void) dealloc
{
    //[candyStack release];
    [gravitySourceStack release];
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
