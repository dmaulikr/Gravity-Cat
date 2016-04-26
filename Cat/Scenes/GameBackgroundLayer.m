//
//  GameBackgroundLayer.m
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import "GameBackgroundLayer.h"

@implementation GameBackgroundLayer

- (id)init
{
    self = [super init];
    if (self != nil) {

        /*CCLayerGradient *gradientBackground = [CCLayerGradient layerWithColor:ccc4(0,0,0,255)
                                                                     fadingTo:ccc4(0,174,255,255)
                                                                  alongVector:ccp(0,1)]; 
        
        [self addChild:gradientBackground];
         */
        /*        CCSprite* background = [CCSprite spriteWithFile:@"fon.png"];
        //CGSize s = [CCDirector sharedDirector].winSize;
        background.anchorPoint = CGPointMake(0, 0);
        [self addChild:background];
         */    }
    return self;
}

@end


