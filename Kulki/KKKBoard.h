//
//  Board.h
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "KKKBall.h"

@protocol KKKGameDelegate <NSObject>

-(void)didUpdateScore:(int)newScore;
-(void)didEndGame;

@end

@interface KKKBoard : SKSpriteNode <KKKBallDelegate>
@property (nonatomic) NSMutableArray *board;
@property (nonatomic,weak) id<KKKGameDelegate> delegate;

@end
