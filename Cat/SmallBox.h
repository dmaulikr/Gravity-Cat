//
//  SmallBox.h
//  Cat
//
//  Created by Igor on 21.01.14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "Box2D.h"

@interface SmallBox : CCNode {
    b2Body *body;
    CGRect spriteRect;
}

@property(assign)b2Body *body;
@property(assign)CCSprite *sprite;
@property(assign)CGRect spriteRect;

+(id) initSmallBox:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) initSquaredPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName layer:(CCLayer *)layer;
-(void) initSpriteRect;

@end
