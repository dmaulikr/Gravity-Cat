//
//  Butterfly.m
//  Butterfly
//
//  Created by Macbook on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cat.h"
#import "GamePlayLayer.h"
#import "GravityTower.h"

//#define spriteFileName @"Icon-Small-50.png"


@interface Cat (PrivateMethods)
-(id) initCat:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName  layer:(CCLayer*) layer;
-(void) initRagDollSprites:(CCLayer*) layer;
-(void) initGravitySourceStack;
-(void) move;
-(void) updateBodyRotation;
-(void) velocityStable;
-(void) updateBodyGravityState;
@end

static inline float ptm(float d)
{
    return d / PTM_RATIO;
}

NSString* spriteFileName = @"telo.png";

@implementation Cat

@synthesize body,sprite,gravity;
@synthesize legLeft,legRight,armLeft,armRight;

+(id) initCat:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    return [[[self alloc] initCat:position world:world layer:layer] autorelease];
    
}

-(id) initCat:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer
{
    if (self = [super init]) {
        [self initSprite:spriteFileName layer:layer];
        [self initRagDollSprites:layer];
        [self initPhysicalBody:position world:world];
        //[self initGravitySourceStack];
        self.gravity = YES;
        [self schedule:@selector(update:) interval:0.01f];
        
    }
    return self;
}

-(void) initSprite:(NSString *)fileName  layer:(CCLayer*) layer;
{
    sprite = [CCSprite spriteWithFile:fileName];
   // self.sprite = sprite;
    [layer addChild:sprite];
}

-(void) initRagDollSprites:(CCLayer*) layer
{
    leftArmSprite = [CCSprite spriteWithFile:@"lev_ruka.png"];
    [layer addChild:leftArmSprite];
    rightArmSprite= [CCSprite spriteWithFile:@"prav_ruka.png"];
    [layer addChild:rightArmSprite];
    leftLegSprite = [CCSprite spriteWithFile:@"lev_noga.png"];
    [layer addChild:leftLegSprite];
    rightLegSprite = [CCSprite spriteWithFile:@"prav_noga.png"];
    [layer addChild:rightLegSprite];
    
}

-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world
{
    /*
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set((position.x)/PTM_RATIO,(position.y)/PTM_RATIO);;
    body = world->CreateBody(&bodyDef);
    b2FixtureDef boxDef;
    b2PolygonShape box;
    boxDef.friction =0.2;
    boxDef.restitution = 0.2;
    boxDef.density = 0.5f;
    // boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
    box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    boxDef.shape = &box;
    body->SetUserData(self);
    body->CreateFixture(&boxDef);
     */
     
    
    // -------------------------
    // Bodies ------------------
    // -------------------------
    
    // Set these to dynamics bodies
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    
    b2PolygonShape box;
    b2FixtureDef fixtureDef;
    /*
    // Head ------
    b2CircleShape headShape;
    headShape.m_radius = ptm(12.5f);
    fixtureDef.shape = &headShape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.3f;
    bd.position.Set(ptm(position.x), ptm(position.y));
    b2Body *head = world->CreateBody(&bd);
    head->CreateFixture(&fixtureDef);
    head->ApplyLinearImpulse(b2Vec2(random() % 100 - 50.0f, random() % 100 - 50.0f), head->GetWorldCenter());
    
    // -----------
    */
    // Torso1 ----
    box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    fixtureDef.shape = &box;
    fixtureDef.density = 0.5f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.1f;
    bd.position.Set(ptm(position.x), ptm(position.y));
    b2Body *torso1 = world->CreateBody(&bd);
    torso1->CreateFixture(&fixtureDef);
    body=torso1;
    body->SetUserData(self);
    // -----------
    
    // UpperArm --
    fixtureDef.density = 0.5f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.1f;
    fixtureDef.filter.maskBits = b2MaskForNonCollisionBodies;
    
    // Left
    box.SetAsBox(leftArmSprite.contentSize.width/2.0f/PTM_RATIO, leftArmSprite.contentSize.height/2.0f/PTM_RATIO);
    fixtureDef.shape = &box;
    bd.position.Set(ptm(position.x- 20.0f), ptm(position.y -20.0f));
    b2Body *upperArmL = world->CreateBody(&bd);
    upperArmL->CreateFixture(&fixtureDef);
    armLeft = upperArmL;
    
    // Right
    box.SetAsBox(rightArmSprite.contentSize.width/2.0f/PTM_RATIO, rightArmSprite.contentSize.height/2.0f/PTM_RATIO);
    fixtureDef.shape = &box;
    bd.position.Set(ptm(position.x+ 20.0f), ptm(position.y - 20.0f));
    b2Body *upperArmR = world->CreateBody(&bd);
    upperArmR->CreateFixture(&fixtureDef);
    armRight=upperArmR;
    
    
    // UpperLeg --
    fixtureDef.density = 0.5f;
    fixtureDef.friction = 0.4f;
    fixtureDef.restitution = 0.1f;
        fixtureDef.filter.maskBits = b2MaskForNonCollisionBodies;
    
    // Left
    box.SetAsBox(leftLegSprite.contentSize.width/2.0f/PTM_RATIO, leftLegSprite.contentSize.height/2.0f/PTM_RATIO);
    fixtureDef.shape = &box;
    bd.position.Set(ptm(position.x- 16.0f), ptm(position.y - 35.0f));
    b2Body *upperLegL = world->CreateBody(&bd);
    upperLegL->CreateFixture(&fixtureDef);
    legLeft = upperLegL;
    
    // Right
    box.SetAsBox(rightLegSprite.contentSize.width/2.0f/PTM_RATIO, rightLegSprite.contentSize.height/2.0f/PTM_RATIO);
    fixtureDef.shape = &box;
    bd.position.Set(ptm(position.x+ 16.0f), ptm(position.y - 35.0f));
    b2Body *upperLegR = world->CreateBody(&bd);
    upperLegR->CreateFixture(&fixtureDef);
    legRight = upperLegR;
     
    
    // -----------
    
    // -------------------------
    // Joints ------------------
    // -------------------------
    
    b2RevoluteJointDef jd;
    jd.enableLimit = true;
    /*
    // Head to shoulders
    jd.lowerAngle = -40.0f / (180.0f / M_PI);
    jd.upperAngle = 40.0f / (180.0f / M_PI);
    jd.Initialize(torso1, head, b2Vec2(ptm(position.x), ptm(position.y+ 15.0f)));
    world->CreateJoint(&jd);
    */
    // Upper arm to shoulders --
    // Left
    jd.lowerAngle = -65.0f / (180.0f / M_PI);
    jd.upperAngle = 100.0f / (180.0f / M_PI);
    jd.Initialize(torso1, upperArmL, b2Vec2(ptm(position.x - 15.0f), ptm(position.y - 17.0f)));
    world->CreateJoint(&jd);
    
    // Right
    jd.lowerAngle = -100.0f / (180.0f / M_PI);
    jd.upperAngle = 65.0f / (180.0f / M_PI);
    jd.Initialize(torso1, upperArmR, b2Vec2(ptm(position.x + 15.0f), ptm(position.y - 17.0f)));
    world->CreateJoint(&jd);
    // -------------------------
    
    // Torso to upper leg ------
    // Left
    jd.lowerAngle = -25.0f / (180.0f / M_PI);
    jd.upperAngle = 45.0f / (180.0f / M_PI);
    jd.Initialize(torso1, upperLegL, b2Vec2(ptm(position.x - 14.0f), ptm(position.y - 30.0f)));
    world->CreateJoint(&jd);
    
    // Right
    jd.lowerAngle = -45.0f / (180.0f / M_PI);
    jd.upperAngle = 25.0f / (180.0f / M_PI);
    jd.Initialize(torso1, upperLegR, b2Vec2(ptm(position.x + 14.0f), ptm(position.y - 30.0f)));
    world->CreateJoint(&jd);
    
  
}

-(void) initGravitySourceStack
{
    GamePlayLayer* gameLayer = [GamePlayLayer sharedGamePlayLayer];
    gravitySourceStack = [gameLayer sharedGravitySourceStack];
}

-(void) initWeaponStack:(NSMutableArray*) stack
{
    gravitySourceStack = stack;
}

-(void) update: (ccTime) dt
{
    
    self.sprite.position = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body -> GetPosition().y * PTM_RATIO);
    self.sprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(body->GetAngle());
     
    //[self move];
    
    leftArmSprite.position = CGPointMake(self.armLeft->GetPosition().x * PTM_RATIO, self.armLeft -> GetPosition().y * PTM_RATIO);
    leftArmSprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(self.armLeft->GetAngle());
    
    leftLegSprite.position = CGPointMake(self.legLeft->GetPosition().x * PTM_RATIO, self.legLeft -> GetPosition().y * PTM_RATIO);
    leftLegSprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(self.legLeft->GetAngle());
    
    rightArmSprite.position = CGPointMake(self.armRight->GetPosition().x * PTM_RATIO, self.armRight -> GetPosition().y * PTM_RATIO);
    rightArmSprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(self.armRight->GetAngle());
    
    rightLegSprite.position = CGPointMake(self.legRight->GetPosition().x * PTM_RATIO, self.legRight -> GetPosition().y * PTM_RATIO);
    rightLegSprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(self.legRight->GetAngle());
    
    
    [self velocityStable];
    [self bodySetGravity];
    [self updateBodyGravityState];
    
    
}
/*
-(void) move
{
    if (gravitySourceStack!=NULL)
    {
        int gravitySourcesON = 0;
        for(GravitySource* light in gravitySourceStack)
        {

            if (light.state == ON)
            {
                gravitySourcesON = gravitySourcesON+1;
                self.gravity=NO;
                // self.body->SetLinearVelocity(light.body->GetPosition()-self.body->GetPosition());
                b2Vec2 center = light.body->GetPosition();
                b2Vec2 position = self.body->GetPosition();
                b2Vec2 d = center - position;
                float force = d.Length();
                //   CCLOG(@"%f",force);
                
                //float force = 200/ d.LengthSquared();
                d.Normalize();
                b2Vec2 F = force * d;
                self.body->ApplyForce(F, position);
                //self.body->SetLinearVelocity(finalySpeedVector);
            }
        }
        if (gravitySourcesON == 0) {
            self.gravity = OFF;
        }
        
    }
}
 */

-(void) velocityStable
{
    if (self.gravity == NO)
    {
    b2Vec2 currentVelocity = self.body->GetLinearVelocity();
    b2Vec2 velocityStabile = -1.0f * currentVelocity;
    self.body->ApplyForceToCenter(velocityStabile);
    }
}

-(void) updateBodyRotation
{
    b2Vec2 velocity = body->GetLinearVelocity();
    float angle = -1*atan2f(velocity.x, velocity.y);
    body->SetTransform(body->GetPosition(), angle);
}

-(void) updateBodyGravityState
{
    int activeTowers = 0;
    //CCLOG(@"HUY");
    for (WeaponEntity* tower in gravitySourceStack)
    {
        if (tower.state == Active)
        {
            activeTowers = activeTowers+1;
            self.gravity = NO;
        }
    }
    if (activeTowers == 0)
    {
        self.gravity = YES;
    }
    
}

-(void) bodySetGravity
{
  if (gravity == NO)
  {
      body->SetGravityScale(0.0f);
  }
  if(gravity == YES)
  {
      body->SetGravityScale(1.0f);
  }
}

-(void) dealloc
{
	[super dealloc];
}

@end
