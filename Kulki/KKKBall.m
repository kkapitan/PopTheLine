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
    NSDictionary *textureCache = [KKKBall textureCache];
    self = [super initWithTexture:(SKTexture*)textureCache[color]];
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
    static NSDictionary *imageNameKeyColorValue;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNameKeyColorValue = @{
            @"Green":@"Green.png",
            @"Red":@"Red.png",
            @"Yellow":@"Yellow.png",
            @"Blue":@"Blue.png",
            @"Brown":@"Brown.png"
        };

    });
    return imageNameKeyColorValue;
}

+(NSDictionary*)textureCache
{
    static NSMutableDictionary *textureCache;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textureCache = [NSMutableDictionary dictionary];
        NSDictionary *imageNameForColor = [KKKBall imageNameForColorDictionary];
        for (NSString *color in imageNameForColor) {
            
            SKTexture *texture = [SKTexture textureWithImageNamed:imageNameForColor[color]];
            textureCache[color] = texture;
        }
    });
    return textureCache;
}


-(void)select
{
    [self runAction:[KKKBall actionForSelection] withKey:@"selected"];
    
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
    
    [self runAction:[KKKBall actionForRemoval]];
    
}

+(SKAction*)actionForSelection{
    
    static SKAction* selectionAction;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SKAction *pulseIn =  [SKAction scaleTo: 1.0 duration:0.2];
        SKAction *pulseOut = [SKAction scaleTo:0.8 duration:0.2];
        SKAction *selected = [SKAction sequence:@[pulseOut,pulseIn]];
        selectionAction = [SKAction repeatActionForever:selected];
    });
    return selectionAction;
}

+(SKAction*)actionForRemoval{
    
    static SKAction* removalAction;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        removalAction = [SKAction sequence:@[
            [SKAction scaleTo:0.1 duration:0.2],
            [SKAction removeFromParent]]];
    });
    return removalAction;
}


@end
