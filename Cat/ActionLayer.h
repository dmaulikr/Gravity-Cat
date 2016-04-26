//
//  ActionLayer.h
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Gameconfig.h"
#import "GravitySource.h"
#import "Cat.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

// ActionLayer
@interface ActionLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    NSMutableArray *gravitySourceStack;
    //NSMutableArray *candyStack;
}

// returns a CCScene that contains the ActionLayer as the only child
+(CCScene *) scene;
+(ActionLayer*) sharedGameScene;
-(NSMutableArray*) sharedGravitySourceStack;
-(void) initPhysics;
-(void) initLightSourceStack;
-(void) restart;
-(void) initCandyStack;

@end
