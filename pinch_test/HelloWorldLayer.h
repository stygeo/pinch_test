//
//  HelloWorldLayer.h
//  pinch_test
//
//  Created by Jeffrey Wilcke on 11/21/12.
//  Copyright Indie Pandas 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGFloat initialDistance;
    CGFloat zoomFactor;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
