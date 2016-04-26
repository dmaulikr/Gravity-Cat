//
//  WeaponEntity.h
//  Cat
//
//  Created by Macbook on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "Box2D.h"

typedef enum WState
{
    Active,
    Disactive
} WState;

@interface WeaponEntity : CCNode {
    b2Body *body;
    WState state;
    CGRect spriteRect;
}

@property(assign)b2Body *body;
@property(assign)CCSprite *sprite;
@property(assign)WState state;
@property(assign)CGRect spriteRect;

-(id) initWeaponEntity:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) initSquaredPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName layer:(CCLayer *)layer;
-(void) initSpriteRect;
-(void) registerTouch:(UITouch *)touch ;


@end
