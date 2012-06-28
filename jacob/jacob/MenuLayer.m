//
//  MenuLayer.m
//  jacob
//
//  Created by q on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GrainLayer.h"

@implementation MenuLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		

        CCSprite *menuLayerSprite = [CCSprite spriteWithFile:@"menu_layer.png"];
        menuLayerSprite.position = ccp(1024/2, 768/2);
        [self addChild:menuLayerSprite z:0];
    
        CCMenuItem* btn_meat_fish = [CCMenuItemImage itemFromNormalImage:@"menu_button.png" selectedImage:nil target:self selector:@selector(meat_fish_Click)];
        btn_meat_fish.position = ccp(260, 480);      
        
        CCMenuItem* btn_sweet_salty = [CCMenuItemImage itemFromNormalImage:@"menu_button.png" selectedImage:nil target:self selector:@selector(sweet_salty_Click)];
        btn_sweet_salty.position = ccp(800, 480);
       
        CCMenuItem* btn_fruit_vegetable = [CCMenuItemImage itemFromNormalImage:@"menu_button.png" selectedImage:nil target:self selector:@selector(fruit_vegetale_Click)];
        btn_fruit_vegetable.position = ccp(800, 180);
        
        CCMenuItem* btn_water = [CCMenuItemImage itemFromNormalImage:@"menu_button1.png" selectedImage:nil target:self selector:@selector(water_Click)];
        btn_water.position = ccp(300, 160);
        
        CCMenuItem* btn_grain = [CCMenuItemImage itemFromNormalImage:@"menu_button2.png" selectedImage:nil target:self selector:@selector(grain_Click)];
        btn_grain.position = ccp(190, 310);
        
        CCMenu* menu = [CCMenu menuWithItems:btn_meat_fish, btn_sweet_salty, btn_fruit_vegetable, btn_water, btn_grain, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:1];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"menu_layer.png"];
	[super dealloc];
}

- (void) meat_fish_Click
{
    NSLog(@"meat fish clicked");
}
- (void) sweet_salty_Click
{
    NSLog(@"sweet_salty clicked");
}
- (void) fruit_vegetale_Click
{
    NSLog(@"fruit clicked");
}
- (void) water_Click
{
    NSLog(@"water clicked");
}
- (void) grain_Click
{
  [[CCDirector sharedDirector] replaceScene:[GrainLayer node]];
    
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSplitRows transitionWithDuration:1.0f scene:[GrainLayer node]]];
}
@end
