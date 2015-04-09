//
//  KKKGameData.h
//  Kulki
//
//  Created by Krzysztof Kapitan on 09.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKKGameData : NSObject <NSCoding>

@property(nonatomic) int highScore;

+(KKKGameData*)sharedGameData;

@end
