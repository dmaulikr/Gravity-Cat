//
//  GravityGun.h
//  Cat
//
//  Created by Macbook on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WeaponEntity.h"

@interface GravityGun : WeaponEntity {
    NSMutableArray *bodiesInShootRadius;
}

@property(assign) b2Body *bubbleBody;

+(id) initGravityGun:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) getBodyForIteration:(b2Body *)bodyA;
-(void) removeBodyFromIterations:(b2Body *)bodyA;

@end
