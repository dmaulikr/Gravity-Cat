//
//  SmallBox.m
//  Cat
//
//  Created by Igor on 21.01.14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "SmallBox.h"

@interface SmallBox (PrivateMethods)
-(id) initSmallBox:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
@end



@implementation SmallBox

@synthesize body,sprite,spriteRect;

+(id) initSmallBox:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    return [[[self alloc] initSmallBox:fileName atPosition:position world:world layer:layer] autorelease];
    
}

-(id) initSmallBox:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    if((self = [super init])) {
        [self initSprite:fileName layer:layer];
        [self initSquaredPhysicalBody:position world:world];
        [self initSpriteRect];
    }
	return self;
}

-(void) initSquaredPhysicalBody:(CGPoint)position world:(b2World *)world;
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
    //boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
    box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    boxDef.shape = &box;
    body->CreateFixture(&boxDef);
}

-(void) initSprite:(NSString *)fileName layer:(CCLayer *)layer
{
    self.sprite = [CCSprite spriteWithFile:fileName];
    [layer addChild:self.sprite];
}

-(void) initSpriteRect
{
    self.sprite.position = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body -> GetPosition().y * PTM_RATIO);
    CGSize size = [self.sprite contentSize];
    spriteRect = CGRectMake((self.sprite.position.x-(size.width/2)), self.sprite.position.y-(size.height/2), size.width, size.height);
    self.spriteRect = spriteRect;
}

-(void) dealloc
{
	[super dealloc];
}





@end
