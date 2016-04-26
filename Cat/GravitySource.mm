//
//  LightSource.m
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GravitySource.h"


@interface GravitySource (PrivateMethods)
-(id) initGravitySource:(NSString*)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer*) layer;
-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName  layer:(CCLayer*) layer;
-(void) initSpriteRect;
@end


@implementation GravitySource

@synthesize body,sprite,spriteRect,state;


+(id) initGravitySource:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    return [[[self alloc] initGravitySource:fileName atPosition:position world:world layer:layer] autorelease];
    
}

-(id) initGravitySource:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    if (self = [super init]) {
        
        [self initSprite:fileName layer:layer];
        [self initPhysicalBody:position world:world];
        [self initSpriteRect];
        self.state = OFF;
        [self schedule:@selector(update:) interval:0.01f];
    }
    return self;
}

-(void) initSprite:(NSString *)fileName layer:(CCLayer *)layer
{
    sprite = [CCSprite spriteWithFile:fileName];
    self.sprite = sprite;
    //self.sprite.color = ccMAGENTA;
    [layer addChild:self.sprite];
}

-(void) initSpriteRect
{
    self.sprite.position = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body -> GetPosition().y * PTM_RATIO);
    CGSize size = [self.sprite contentSize];
    spriteRect = CGRectMake((self.sprite.position.x-(size.width/2)), self.sprite.position.y-(size.height/2), size.width, size.height);
    self.spriteRect = spriteRect;
}

-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set((position.x)/PTM_RATIO,(position.y)/PTM_RATIO);;
    body = world->CreateBody(&bodyDef);
    b2FixtureDef boxDef;
    b2PolygonShape box;
    boxDef.friction =0.2;
    boxDef.restitution = 0.2;
    boxDef.density = 1.0f;
    boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
    box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    boxDef.shape = &box;
    body->CreateFixture(&boxDef);
}

-(void) update: (ccTime) dt
{
    self.sprite.position = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body -> GetPosition().y * PTM_RATIO);
    self.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    if (self.state == ON)
    {
        self.sprite.color = ccMAGENTA;
    }
    else
    {
        self.sprite.color = ccWHITE;
    }
}


/*
 -(CGRect)spriteRect
 {
 CGSize size = [self.sprite contentSize];
 return CGRectMake((self.sprite.position.x-(size.width/2)), self.sprite.position.y-(size.height/2), size.width, size.height);
 }
 */

-(void) dealloc
{
	[super dealloc];
}

@end