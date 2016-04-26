//
//  GravityGun.m
//  Cat
//
//  Created by Macbook on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GravityGun.h"

@interface GravityGun (PrivateMethods)
-(id) initGravityGun:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) initBubbleBody:(b2World *)world atPosition:(CGPoint)position;
@end


@implementation GravityGun

@synthesize bubbleBody;

+(id) initGravityGun:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    return [[[self alloc] initGravityGun:position world:world layer:layer] autorelease];
}

-(id) initGravityGun:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
 	if(self = [super initWeaponEntity:@"Icon-72.png" atPosition:position world:world layer:layer]) {
        self.state = Disactive;
        [self initBubbleBody:world atPosition:position];
        bodiesInShootRadius = [[NSMutableArray alloc] init];
        [self schedule:@selector(update:)];
    }
	return self;
}

-(void) initBubbleBody:(b2World *)world atPosition:(CGPoint)position
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set((position.x)/PTM_RATIO,(position.y)/PTM_RATIO);
    bubbleBody = world->CreateBody(&bodyDef);
    b2CircleShape bubbleShape;
    bubbleShape.m_radius = 5.0f;
    b2FixtureDef bubbleFd;
    bubbleFd.shape = &bubbleShape;
    bubbleFd.isSensor = YES;
    //bubbleFd.filter.categoryBits = 0
    //bubbleFd.filter.maskBits = b2MaskForNonCollisionBodies;
    //bubbleFd.filter.maskBits = 0;
    bubbleBody->SetUserData(self);
    bubbleBody->CreateFixture(&bubbleFd);

    
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
        if (bodiesInShootRadius != nil)
        {
            for (NSValue *val in bodiesInShootRadius)
            {
                b2Body* bodyInShootRadius;
                [val getValue:&bodyInShootRadius];
                b2Vec2 center = self.body->GetPosition();
                b2Vec2 position = bodyInShootRadius->GetPosition();
                b2Vec2 d = center - position;
                //float force = d.Length();
                //   CCLOG(@"%f",force);
                
                //float force = 100/ d.Length();
                d.Normalize();
                float force = -1500;
                b2Vec2 F = force * d;
                bodyInShootRadius->ApplyForce(F, position);

        }
        self.state = Disactive;
    }
}
}

-(void) getBodyForIteration:(b2Body *)bodyA
{
    NSValue *bodyVal = [NSValue valueWithPointer:bodyA];
    [bodiesInShootRadius addObject:bodyVal];
}

-(void) removeBodyFromIterations:(b2Body *)bodyA
{
    NSValue *bodyVal = [NSValue valueWithPointer:bodyA];
    [bodiesInShootRadius removeObject:bodyVal];
}



-(void) dealloc
{
    [bodiesInShootRadius release];
    [super dealloc];
}

@end
