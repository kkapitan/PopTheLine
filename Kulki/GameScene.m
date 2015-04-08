//
//  GameScene.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "KKKScrollingBackground.h"


@interface GameScene ()
@property KKKScrollingBackground *backgroundNode;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.scene.backgroundColor = [SKColor greenColor];
    
    
    self.backgroundNode = [[KKKScrollingBackground alloc] initWithImageNamed:@"Jungle.png"];
    [self addChild:self.backgroundNode];
    
    KKKBoard* board = [[KKKBoard alloc] initWithImageNamed:@"GameGrid.png"];
    
    board.alpha = 0.8;
    board.position = CGPointMake(CGRectGetMidX(self.scene.frame),CGRectGetMidY(self.scene.frame));
    board.userInteractionEnabled = YES;
    board.delegate = self.boardDelegate;
    board.zPosition = 100;
    
    [board setupInitialState];

    [self addChild:board];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
    [self.backgroundNode updateWithTime:currentTime];
}

@end
