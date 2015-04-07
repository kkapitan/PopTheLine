//
//  KKKScrollingBackground.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 07.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "KKKScrollingBackground.h"

@interface KKKScrollingBackground ()
@property (nonatomic) CGFloat timeSinceLastUpdate;
@property (nonatomic) CFTimeInterval lastUpdateTime;
@end

static const float BG_VELOCITY = 15.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}


@implementation KKKScrollingBackground


-(instancetype)initWithImageNamed:(NSString *)name{
    self = [super init];
    for(int i = 0; i < 2; i++){
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:name];
        bg.position = CGPointMake(i * bg.size.width,0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
    return self;
}

- (void)moveBackground;
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,self.timeSinceLastUpdate);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
}

-(void)updateWithTime:(CFTimeInterval)time{
    if(self.lastUpdateTime){
        self.timeSinceLastUpdate = time - self.lastUpdateTime;
    }
    else{
        self.timeSinceLastUpdate = 0;
    }
    self.lastUpdateTime = time;
    [self moveBackground];
}


@end
