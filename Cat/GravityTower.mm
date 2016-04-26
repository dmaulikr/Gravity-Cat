//
//  GravityTower.m
//  Cat
//
//  Created by Macbook on 21.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GravityTower.h"
#import "Cat.h"
#import "GamePlayLayer.h"

@interface GravityTower (PrivateMethods)
-(id) initGravityTower:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) getCatForIterations;
@end

@implementation GravityTower

Cat* kitty;

+(id) initGravityTower:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    return [[[self alloc] initGravityTower:position world:world layer:layer] autorelease];
}

-(id) initGravityTower:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
 	if(self = [super initWeaponEntity:@"Icon-72.png" atPosition:position world:world layer:layer]) {
        [self getCatForIterations];
        self.state = Disactive;
        [self scheduleUpdate];
    }
	return self;
}

-(void) getCatForIterations
{
    GamePlayLayer* gameLayer = [GamePlayLayer sharedGamePlayLayer];
    kitty = [gameLayer sharedGamePlayLayerHero];
}

-(void) update: (ccTime) dt
{
    if (self.state == Active)
    {
        self.sprite.color = ccMAGENTA;
    }
    else
    {
        self.sprite.color = ccWHITE;
        
    }
            if (self.state == Active)
            {
                //kitty.gravity=NO;
                b2Vec2 center = self.body->GetPosition();
                b2Vec2 position = kitty.body->GetPosition();
                b2Vec2 d = center - position;
                float force = d.Length();
                d.Normalize();
                b2Vec2 F = force * d;
                kitty.body->ApplyForce(F, position);
            }
        if (self.state == Disactive)
        {
       // kitty.gravity=YES;
        }

}


@end
