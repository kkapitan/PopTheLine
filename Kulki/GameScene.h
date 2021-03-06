//
//  GameScene.h
//  Kulki
//

//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "KKKBoard.h"

@interface GameScene : SKScene
@property (nonatomic, weak) id<KKKGameDelegate> boardDelegate;
@end
