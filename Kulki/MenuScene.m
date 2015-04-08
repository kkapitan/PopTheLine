//
//  MenuScene.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 07.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "MenuScene.h"
#import "KKKScrollingBackground.h"

@interface MenuScene ()
@property (nonatomic) KKKScrollingBackground *backgroundNode;
@end

@implementation MenuScene

-(void)didMoveToView:(SKView *)view{
    
    self.backgroundNode = [[KKKScrollingBackground alloc] initWithImageNamed:@"Jungle.png"];
    [self addChild:self.backgroundNode];
}

-(void)update:(NSTimeInterval)currentTime{
    [self.backgroundNode updateWithTime:currentTime];
}

@end
