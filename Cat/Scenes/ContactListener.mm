/*
 *  ContactListener.mm
 *  PhysicsBox2d
 *
 *  Created by Steffen Itterheim on 17.09.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

#import "ContactListener.h"


void ContactListener::BeginContact(b2Contact* contact)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    id userDataA = (id)bodyA->GetUserData();
    id userDataB = (id)bodyB->GetUserData();

    if ([userDataA isKindOfClass:[Cat class]] && [userDataB isKindOfClass:[GravityGun class]])
    {
        GravityGun* gravitygun = (GravityGun*)userDataB;
        [gravitygun getBodyForIteration:bodyA];
    }
}





void ContactListener::EndContact(b2Contact* contact)
{
    
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    id userDataA = (id)bodyA->GetUserData();
    id userDataB = (id)bodyB->GetUserData();
    
    if ([userDataA isKindOfClass:[Cat class]] && [userDataB isKindOfClass:[GravityGun class]])
    {
        GravityGun* gravitygun = (GravityGun*)userDataB;
        [gravitygun removeBodyFromIterations:bodyA];
    }
    
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
}


