//
//  GrainLayer.m
//  jacob
//
//  Created by q on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GrainLayer.h"


@implementation GrainLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GrainLayer *layer = [GrainLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {
        [self setIsTouchEnabled:YES];
        flag = 1;
        _winSize		= [[CCDirector sharedDirector] winSize];
        
		CCSprite* skySprite = [CCSprite spriteWithFile:@"wheatfield_sky.png"]; 
        skySprite.position = ccp(_winSize.width/2, _winSize.height/2);
        [self addChild:skySprite z:0];
        
        groundSprite = [CCSprite spriteWithFile:@"wheatField_ground.png"];
        groundSprite.position = ccp(_winSize.width/2, _winSize.height/2);
        [self addChild:groundSprite z:1];
        
        CCSprite* groundSprite1 = [CCSprite spriteWithFile:@"wheat_back1.png"];
        groundSprite1.position = ccp(_winSize.width/2, _winSize.height/2);
        [self addChild:groundSprite1 z:2];
        
        groundSprite2 = [CCSprite spriteWithFile:@"wheat_front.png"];
        groundSprite2.position = ccp(_winSize.width/2, -_winSize.height/2);
        [self addChild:groundSprite2 z:3];
        
        tractor = [CCSprite spriteWithFile:@"tractor.png"];
        [tractor setAnchorPoint:CGPointMake(0, 0)];
        tractor.position = ccp(0, 0);
        tractor.tag = 0;
        [self addChild:tractor z:4];
        
        
        CCSpriteBatchNode* windmillLayer = [CCSpriteBatchNode batchNodeWithFile:@"windmill.png"];
        [[windmillLayer texture]setAliasTexParameters];
        
        //init windmill
        windmill_body = [CCSprite spriteWithSpriteFrameName:@"windmill_body.png"];
        [windmill_body setPosition:CGPointMake(100, 500)];
        windmill_wing = [CCSprite spriteWithSpriteFrameName:@"windmill_wing.png"];
        [windmill_wing setPosition:CGPointMake(120, 530)];
        [windmill_wing setAnchorPoint:ccp(0.5f, 0.5f)];
        [windmillLayer addChild:windmill_body];
        [windmillLayer addChild:windmill_wing];
        id rotation_action = [CCSequence actions: [CCRotateBy actionWithDuration:2 angle:360], nil];
        id wing_action = [CCRepeatForever actionWithAction:rotation_action];
        [windmill_wing runAction:wing_action];
        
        [self schedule:@selector(moveCloud:) interval:2];
        [self addChild:windmillLayer z:1];
    }
	return self;
}
- (void) dealloc
{
	[super dealloc];
}
- (void) moveCloud:(ccTime) dt
{
    int minY = _winSize.height/2;
    int maxY = _winSize.height;
    int rangeY = maxY - minY;
    
    int actualY = (arc4random() % rangeY + minY);
    
    int cloud_id = arc4random() % 3;
    switch (cloud_id) {
        case 0:
             cloud = [CCSprite spriteWithSpriteFrameName:@"wheatfield_clouds1.png"];
            break;
        case 1:
            cloud = [CCSprite spriteWithSpriteFrameName:@"wheatfield_clouds2.png"];
            break;
        default:
            cloud = [CCSprite spriteWithSpriteFrameName:@"wheatfield_clouds3.png"];
            break;
    }
    cloud.position = ccp(0, actualY);
    [self addChild:cloud z:0];
   
    int minDuration = 8.0;
    int maxDuration = 10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(_winSize.width, actualY)];
    
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveCloudFinished:)];
    [cloud runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}
- (void) moveCloudFinished:(id)sender
{
    CCSprite* clouds = (CCSprite*)sender;
    [self removeChild:clouds cleanup:YES];
}
- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint touchLocation = [touch locationInView: [touch view]];	
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];    
    if(flag == 1 || flag == 2)
    {
        if(CGRectContainsPoint([tractor boundingBox], prevLocation))
        {
            float dx = touchLocation.x - prevLocation.x;
            float dy = touchLocation.y - prevLocation.y; 
            CGPoint pos = tractor.position;
            tractor.position = CGPointMake(pos.x + dx, pos.y + dy);
            flag = 2;
        }
    }
}
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if(flag == 2)
    {
        flag = 3;
        [self removeChild:tractor cleanup:YES];
    
        tractor_side = [CCSprite spriteWithFile:@"tractor_side.png"];
        tractor_side.anchorPoint = CGPointMake(1.0, 0.0);
        tractor_side.position = ccp(_winSize.width, 0);
        
        [self addChild:tractor_side z:4];
    
        id field_action = [CCMoveTo actionWithDuration:2 position:ccp(_winSize.width/2, _winSize.height/2)];
        [groundSprite2 runAction:field_action];
        
        
        id actionMove = [CCMoveTo actionWithDuration:3 position:ccp(0, 0)];
        
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(moveCloudFinished:)];
        
        //id tractor_action = [CCMoveTo actionWithDuration:3 position:ccp(0, 0)];        
        //[tractor_side runAction:tractor_action];
        [tractor_side runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
}
@end
