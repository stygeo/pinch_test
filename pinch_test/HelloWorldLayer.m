//
//  HelloWorldLayer.m
//  pinch_test
//
//  Created by Jeffrey Wilcke on 11/21/12.
//  Copyright Indie Pandas 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		initialDistance = 0.0f;
        zoomFactor = 1.0f;
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 + 20 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
        CCSprite *s = [CCSprite spriteWithFile:@"Default.png"];
        s.position = ccp(size.width = 2, size.height /2);
        [self addChild:s];
        [self setTouchEnabled:YES];
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achievementViewController = [[GKAchievementViewController alloc] init];
			achievementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achievementViewController animated:YES];
			
			[achievementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] == 1) {
        // Drag
    } else if([touches count] == 2) {
        NSArray *twoTouch = [touches allObjects];
        UITouch *tOne = [twoTouch objectAtIndex:0];
        UITouch *tTwo = [twoTouch objectAtIndex:1];
        
        CGPoint firstTouch = [tOne locationInView:[tOne view]];
        CGPoint secondTouch = [tTwo locationInView:[tTwo view]];
        
        initialDistance = sqrt(pow(firstTouch.x - secondTouch.x, 2.0f) + pow(firstTouch.y - secondTouch.y, 2.0f));
    }    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] == 1) {
        // Drag
    } else if([touches count] == 2) {
        NSArray *twoTouch = [touches allObjects];
        UITouch *tOne = [twoTouch objectAtIndex:0];
        UITouch *tTwo = [twoTouch objectAtIndex:1];
        
        CGPoint firstTouch = [tOne locationInView:[tOne view]];
        CGPoint secondTouch = [tTwo locationInView:[tTwo view]];
        
        CGFloat currentDistance = sqrt(pow(firstTouch.x - secondTouch.x, 2.0f) + pow(firstTouch.y - secondTouch.y, 2.0f));
        
        if(initialDistance == 0) {
            initialDistance = currentDistance;
        } else if((currentDistance - initialDistance) > 0) {
            NSLog(@"zoom in");
            if(self.scale < 1.0f) {
                zoomFactor += zoomFactor * 0.05f;
                self.scale = zoomFactor;
            }
            
            initialDistance = currentDistance;
        } else if((currentDistance - initialDistance) < 0) {
            NSLog(@"zoom out");
            if(self.scale > 0.5f) {
                zoomFactor -= zoomFactor * 0.05f;
                self.scale = zoomFactor;
            }
            
            initialDistance = currentDistance;
        }
                        NSLog(@"Scale: %f", self.scale);
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
