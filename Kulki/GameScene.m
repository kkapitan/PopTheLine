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
@property UILabel *scoreLabel;
@property NSMutableArray *nextBallImageViews;
@property KKKScrollingBackground *backgroundNode;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.scene.backgroundColor = [SKColor greenColor];
    
    self.scoreLabel = (UILabel*)[self.view viewWithTag:100];
    self.nextBallImageViews = [NSMutableArray array];
    for(int i = 110; i <= 112; i++){
        [self.nextBallImageViews addObject:[self.view viewWithTag:i]];
    }
    
    /*SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"jungle.png"];
    background.anchorPoint = CGPointZero;
    [self.scene addChild:background];
    */
    
    self.backgroundNode = [[KKKScrollingBackground alloc] initWithImageNamed:@"jungle.png"];
    [self addChild:self.backgroundNode];
    
    KKKBoard* board = [[KKKBoard alloc] initWithImageNamed:@"GameGrid.png"];
    
    board.alpha = 0.8;
    board.position = CGPointMake(CGRectGetMidX(self.scene.frame),CGRectGetMidY(self.scene.frame));
    board.userInteractionEnabled = YES;
    board.delegate = self;
    board.zPosition = 100;
    
    [board setupInitialState];

    [self addChild:board];
    
    
    
}

-(void)didUpdateScore:(int)newScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",newScore];
}

-(void)didEndGameWithScore:(int)score{
    GameOverScene *gameOverScene = [GameOverScene sceneWithSize:self.size];
    [self.view presentScene:gameOverScene];
}

-(void)didDrawNewBalls:(NSArray *)balls{
    UIImageView *nextBallImageView;
    for(int i = 0; i < self.nextBallImageViews.count; i++){
        nextBallImageView = (UIImageView*)self.nextBallImageViews[i];
        nextBallImageView.image = nil;
    }
    
    for(int i = 0; i < balls.count; i++){
        KKKBall *ball = (KKKBall*)balls[i];
        nextBallImageView = (UIImageView*)self.nextBallImageViews[i];
        nextBallImageView.image = [UIImage imageNamed:ball.name];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
    [self.backgroundNode updateWithTime:currentTime];
}

@end
