//
//  GamePlayLayer.h
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "TRBox2D.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GameConfig.h"
#import "GravitySource.h"
#import "Cat.h"
#import "GravityGun.h"
#import "GravityTower.h"
#import "ContactListener.h"
#import "SmallBox.h"

@interface GamePlayLayer : CCLayer
 {
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    NSMutableArray *gravitySourceStack;
    NSMutableArray *weapons;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;

+(GamePlayLayer*) sharedGamePlayLayer;
-(Cat*) sharedGamePlayLayerHero;
-(NSMutableArray*) sharedGravitySourceStack;

-(void) initLightSourceStack;

@end