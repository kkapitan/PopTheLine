//
//  GameOverScene.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 02.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(void)didMoveToView:(SKView *)view{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    label.text = @"Game Over";
    [self addChild:label];
}

@end
