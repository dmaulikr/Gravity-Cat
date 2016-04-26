//
//  GravityTower.h
//  Cat
//
//  Created by Macbook on 21.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WeaponEntity.h"

@interface GravityTower : WeaponEntity {
    
}
+(id) initGravityTower:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;

@end
