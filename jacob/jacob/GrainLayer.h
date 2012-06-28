//
//  GrainLayer.h
//  jacob
//
//  Created by q on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GrainLayer : CCLayer {
    CCSprite* windmill_body;
    CCSprite* windmill_wing;
    CCSprite* cloud;
    CCSprite* tractor;
    CCSprite* tractor_side;
    CCSprite* groundSprite;
    CCSprite* groundSprite2;
    CGSize  _winSize;
    int flag;
}
+(CCScene *) scene;
@end
