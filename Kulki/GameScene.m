//
//  GameScene.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property(nonatomic) SKLabelNode *scoreLabel;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.scene.backgroundColor = [SKColor greenColor];
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"jungle.png"];
    background.anchorPoint = CGPointZero;
    [self.scene addChild:background];
    
    KKKBoard* board = [[KKKBoard alloc] initWithImageNamed:@"GameGrid.png"];
    
    board.alpha = 0.7;
    board.position = CGPointMake(CGRectGetMidX(self.scene.frame),CGRectGetMidY(self.scene.frame));
    board.userInteractionEnabled = YES;
    board.delegate = self;
    [self addChild:board];
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.scoreLabel.text = @"Points: 0";
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame),50);
    [self addChild:self.scoreLabel];
}

-(void)didUpdateScore:(int)newScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"Points: %d",newScore];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
