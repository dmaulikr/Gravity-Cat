//
//  LightSource.h
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Gameconfig.h"
#import "Box2D.h"


typedef enum State
{
    ON,
    OFF
} State;



@interface GravitySource : CCNode  {
    CCSprite* sprite;
    CGRect spriteRect;
}

@property(assign)b2Body *body;
@property(assign)CCSprite *sprite;
@property(assign)State state;
@property(assign)CGRect spriteRect;

+(id) initGravitySource:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;


@end
