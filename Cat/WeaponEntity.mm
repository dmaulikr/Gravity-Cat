//
//  WeaponEntity.m
//  Cat
//
//  Created by Macbook on 20.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WeaponEntity.h"


@implementation WeaponEntity

@synthesize body,sprite,spriteRect,state;
/*
-(void) onEnter
{
    CCTouchDispatcher *dispatcher = [[CCDirector sharedDirector] touchDispatcher];
    int priority = kCCMenuHandlerPriority;
	[dispatcher addTargetedDelegate:self priority: priority swallowsTouches:NO];
}

-(void) onExit
{
    CCTouchDispatcher *dispatcher = [[CCDirector sharedDirector] touchDispatcher];
	[dispatcher removeDelegate:self];
}
 */


-(id) initWeaponEntity:(NSString *)fileName atPosition:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
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
    boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
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

/*
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    // CCLOG(@"%f",location.x);
    // CCLOG(@"%f",location.y);
        if (CGRectContainsPoint(self.spriteRect, location))
        {
            if (self.state == Disactive)
            {
                self.state = Active;
                self.sprite.color = ccMAGENTA;
                return YES;
            }
            else
            {
                self.state = Disactive;
                self.sprite.color = ccWHITE;
                return YES;
 
            }
        }
    return NO;
}
 */

-(void) registerTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView: [touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL: location];
    if (CGRectContainsPoint(self.spriteRect, location))
    {
        if (self.state == Disactive)
        {
            self.state = Active;
            self.sprite.color = ccMAGENTA;
        }
        else
        {
            self.state = Disactive;
            self.sprite.color = ccWHITE;
            
        }
    }

}


@end
