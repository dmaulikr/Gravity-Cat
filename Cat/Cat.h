//
//  Butterfly.h
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Gameconfig.h"
#import "Box2d.h"
#import "GravityGun.h"

@interface Cat : CCNode {
    CCSprite* sprite;
    NSMutableArray* gravitySourceStack;
    CCSprite* leftArmSprite;
    CCSprite* rightArmSprite;
    CCSprite* leftLegSprite;
    CCSprite* rightLegSprite;
}

@property(assign)b2Body *body;
@property(assign)b2Body *armRight;
@property(assign)b2Body *armLeft;
@property(assign)b2Body *legRight;
@property(assign)b2Body *legLeft;

@property(assign)CCSprite *sprite;
@property(assign)BOOL gravity;

+(id) initCat:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) bodySetGravity;
-(void) initWeaponStack:(NSMutableArray*) stack;

@end

