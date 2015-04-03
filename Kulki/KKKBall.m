//
//  Ball.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "KKKBall.h"

@interface KKKBall ()
@end


@implementation KKKBall

+(instancetype)ballWithColor:(NSString*)color
{
    return [[KKKBall alloc] initWithColor:color];
}

-(instancetype)initWithColor:(NSString*)color
{
    NSDictionary *imageNameForColor = [KKKBall imageNameForColorDictionary];
    self = [super initWithImageNamed:imageNameForColor[color]];
    self.name = color;
    return self;
}

+(instancetype)ballWithRandomColor
{
    return [[KKKBall alloc] initWithRandomColor];
}

-(instancetype)initWithRandomColor{
    
    NSDictionary *imageNameForColor = [KKKBall imageNameForColorDictionary];
    int colorId = (int)arc4random()%[imageNameForColor count];
    NSArray *keys = [imageNameForColor allKeys];
    NSString *color = keys[colorId];
    
    return [KKKBall ballWithColor:color];
}

+(NSDictionary*)imageNameForColorDictionary
{
    NSDictionary *imageNameKeyColorValue = @{@"Green":@"green.png",
                                             @"Red":@"red.png", @"Yellow":@"yellow.png",
                                             @"Blue":@"blue.png", @"Brown":@"brown.png"};
    return imageNameKeyColorValue;
}



-(void)select
{
    SKAction *pulseIn =  [SKAction scaleTo: 1.0 duration:0.2];
    SKAction *pulseOut = [SKAction scaleTo:0.8 duration:0.2];
    SKAction *selected = [SKAction sequence:@[pulseOut,pulseIn]];
    
    [self runAction:[SKAction repeatActionForever:selected] withKey:@"selected"];
    
    if(self.delegate)
        [self.delegate didSelectBall:self];
}

-(void)deselect
{
    [self removeActionForKey:@"selected"];
    self.xScale = self.yScale = 1.0;
    if(self.delegate)
        [self.delegate didDeselectBall:self];
}

-(void)moveToGridPoint:(CGPoint)gridPoint withPath:(NSArray*)path
{
    [self deselect];
    
    CGPoint points[path.count];
    CGMutablePathRef ballPath = CGPathCreateMutable();
    
    for(int i = 0;i < path.count; i++){
        NSValue *pointValue = path[i];
        CGPoint point = [pointValue CGPointValue];
        points[i] = point;
    }
    
    CGPathAddLines(ballPath, NULL, points,path.count);
    
    SKAction *move = [SKAction followPath:ballPath asOffset:NO orientToPath:NO speed:300.0];
    SKAction *pulse = [SKAction sequence:@[[SKAction scaleTo:0.5 duration:0.2],
                                           [SKAction scaleTo:1.0 duration:0.2]]];
    
    SKAction *pulseForever = [SKAction repeatActionForever:pulse];
    SKAction *moveSequence = [SKAction sequence:@[move,[SKAction runBlock:^{

        [self removeAllActions];
        [self runAction:[SKAction scaleTo:1.0 duration:0.0]];
        if(self.delegate)
            [self.delegate didMoveBall:self toGridPoint:gridPoint];
    
    }]]];
    
    SKAction *moveGroup = [SKAction group:@[moveSequence,pulseForever]];
    [self runAction: moveGroup];
}

-(void)remove
{
    if(self.delegate)
        [self.delegate didRemoveBall:self];
    
    [self runAction:[SKAction sequence:@[[SKAction scaleTo:0.1 duration:0.2],[SKAction removeFromParent]]]];
    
}




@end
