//
//  KKKGameData.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 09.04.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "KKKGameData.h"

@implementation KKKGameData

static NSString* const KKKGameDataHighScoreKey = @"highScore";

+(instancetype)sharedGameData{
    static KKKGameData* gameData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameData = [self loadInstance];
    });
    return gameData;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.highScore forKey:KKKGameDataHighScoreKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [self init];
    if (self) {
        self.highScore = [coder decodeIntForKey:KKKGameDataHighScoreKey];
    }
    return self;
}

+(NSString*)filePath{
    static NSString* filePath = nil;
    if(!filePath){
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+(instancetype)loadInstance{
    
    NSData* decodedData = [NSData dataWithContentsOfFile:[KKKGameData filePath]];
    if(decodedData){
        KKKGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[KKKGameData alloc] init];
}

-(void)save{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[KKKGameData filePath] atomically:YES];
}

-(void)setHighScore:(int)highScore{
    _highScore = highScore;
    [self save];
}

@end
