//
//  Ball.h
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class KKKBall;

@protocol KKKBallDelegate <NSObject>

-(void)didSelectBall:(KKKBall*)ball;
-(void)didDeselectBall:(KKKBall*)ball;
-(void)didRemoveBall:(KKKBall*)ball;
-(void)didMoveBall:(KKKBall*)ball toGridPoint:(CGPoint)gridPoint;

@end


@interface KKKBall : SKSpriteNode

@property (nonatomic) CGPoint gridPoint;
@property (nonatomic,weak) id<KKKBallDelegate> delegate;

+(instancetype)ballWithColor:(NSString*)color withGridPoint:(CGPoint)gridPoint;
+(instancetype)ballWithRandomColorWithGridPoint:(CGPoint)gridPoint;

-(instancetype)initWithColor:(NSString*)color withGridPoint:(CGPoint)gridPoint;
-(instancetype)initWithRandomColorWithGridPoint:(CGPoint)gridPoint;

-(void)setGridPoint:(CGPoint)gridPoint;

-(void)select;
-(void)deselect;
-(void)moveToGridPoint:(CGPoint)gridPoint withPath:(NSArray*)path;
-(void)remove;

@end

