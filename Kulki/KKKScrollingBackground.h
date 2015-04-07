//
//  KKKScrollingBackground.h
//  Kulki
//
//  Created by Krzysztof Kapitan on 07.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KKKScrollingBackground : SKNode
-(void)updateWithTime:(CFTimeInterval)time;
-(instancetype)initWithImageNamed:(NSString *)name;
@end