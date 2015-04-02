//
//  Board.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "KKKBoard.h"

@interface KKKBoard ()
@property (nonatomic) NSMutableArray* freeX;
@property (nonatomic) NSMutableArray* freeY;
@property (nonatomic) KKKBall *selectedBall;
@property (nonatomic) int score;
@end

@implementation KKKBoard

-(instancetype)initWithImageNamed:(NSString *)name{
    
    self = [super initWithImageNamed:name];
    self.freeX = [NSMutableArray array];
    self.freeY = [NSMutableArray array];
    self.score = 0;
    
    for(int i = 0; i < 9 ; i++){
        for(int j = 0; j < 9; j++){
            [self.freeX addObject:[NSNumber numberWithInt:j]];
            [self.freeY addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    self.board = [[NSMutableArray alloc] initWithCapacity:9];
    for(int i = 0; i < 9; i++){
        self.board[i] = [[NSMutableArray alloc] initWithCapacity:9];
        for(int j = 0; j < 9; j++){
            self.board[i][j] = [NSNull null];
        }
    }
    [self addNewBalls];
    
    return self;
}

-(void)addNewBalls{
    
    long numberOfNewBalls = MIN(3,[self.freeX count]);
    for(int i = 0;i < numberOfNewBalls; i++){
    
        int position = (int)arc4random()%[self.freeX count];
        
        NSNumber *xCoord = self.freeX[position];
        NSNumber *yCoord = self.freeY[position];
        
        CGPoint gridPoint = CGPointMake([xCoord intValue], [yCoord intValue]);
        
        KKKBall *newBall = [KKKBall ballWithRandomColorWithGridPoint:gridPoint];
        self.board[(int)gridPoint.x][(int)gridPoint.y] = newBall;
        newBall.position = [self CGPointForGridPoint:newBall.gridPoint];
        newBall.delegate = self;
        
        [self addChild:newBall];
        
        [self.freeX removeObjectAtIndex:position];
        [self.freeY removeObjectAtIndex:position];
    }
}

-(NSMutableArray*)getPathForBall:(KKKBall*)ball toGridPoint:(CGPoint)gridPoint{
    
    int dx[] = {1,-1,0,0};
    int dy[] = {0,0,1,-1};
    
    CGPoint parent[9][9];
    int minDistance[9][9];
    
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            minDistance[i][j] = 100;
            parent[i][j] = CGPointMake(-1, -1);
        }
    }
    
    CGPoint queue[100];
    int head, tail;
    head = tail = 0;
    
    CGPoint source = ball.gridPoint;
    minDistance[(int)source.x][(int)source.y] = 0;
    queue[head++] = source;
    
    while(head != tail){
        
        CGPoint parentPoint = queue[tail++];
        int sx = parentPoint.x;
        int sy = parentPoint.y;
        
        for(int i = 0;i < 4;i++){
            
            long nx = sx + dx[i];
            long ny = sy + dy[i];
            
            if(nx < 0 || ny < 0 || ny > 8 || nx > 8 )continue;
            if([[self.board[nx][ny] class] isSubclassOfClass:[KKKBall class]])continue;
            
            if( minDistance[nx][ny] > minDistance[sx][sy] + 1){
                minDistance[nx][ny] = minDistance[sx][sy] + 1;
                queue[head++] = CGPointMake(nx, ny);
                parent[nx][ny] = parentPoint;
            }
        }
    }
    
    if( minDistance[(int)gridPoint.x][(int)gridPoint.y]  ==  100){
        return nil;
    }
    
    NSMutableArray *reversePath = [NSMutableArray array];
    CGPoint parentPoint = gridPoint;
    do {
        CGPoint pathElement = parentPoint;
        [reversePath addObject:[NSValue valueWithCGPoint:pathElement]];
        parentPoint = parent[(int)pathElement.x][(int)pathElement.y];
    } while (parentPoint.x != -1.0);
    
    NSMutableArray *path = [NSMutableArray array];
    for(long i = reversePath.count - 1; i >= 0 ; i--){
        CGPoint point = [reversePath[i] CGPointValue];
        [path addObject:[NSValue valueWithCGPoint:[self CGPointForGridPoint:point]]];
    }
    
    return path;
}


-(NSMutableArray*)getLinesToPopIncludingBall:(KKKBall*)ball{
    
    int dxArr[] = {1,-1,0,0,1,-1,1,-1};
    int dyArr[] = {0,0,1,-1,1,-1,-1,1};
    NSMutableArray *lines = [NSMutableArray array];
    NSMutableArray *line = [NSMutableArray array];
    KKKBall *temp;
    
    for (int i = 0;i < 8 ;i++) {

        int dx = dxArr[i];
        int dy = dyArr[i];
        
        long sx = ball.gridPoint.x;
        long sy = ball.gridPoint.y;
        
        sx += dx; sy += dy;
        while(!(sx > 8 || sx < 0  || sy > 8 || sy < 0) &&
              [[self.board[sx][sy] class] isSubclassOfClass:[KKKBall class]]){
            
            temp = (KKKBall*)self.board[sx][sy];
            if([temp.name isEqualToString:ball.name])
                [line addObject:temp];
            else break;
            sx += dx; sy += dy;
        }
        
        if(i % 2){
            [line addObject:ball];
            if(line.count >= 5)
                [lines addObject:[line copy]];
            [line removeAllObjects];
        }
    }
    return lines;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [touches enumerateObjectsUsingBlock:^(id obj,BOOL *stop){
       
        UITouch *touch = (UITouch*)obj;
        CGPoint grid = [self gridPointForCGPoint:[touch locationInNode:self]];
        id gridElement = self.board[(int)grid.x][(int)grid.y];
        
        if( [[gridElement class] isSubclassOfClass: [KKKBall class]]){
            
            KKKBall *ball = (KKKBall*) gridElement;
            if(self.selectedBall)
                [self.selectedBall deselect];
            [ball select];
            
        }else if(self.selectedBall){
            NSArray *path = [self getPathForBall:self.selectedBall toGridPoint:grid];
            if(path){
                [self.selectedBall moveToGridPoint:grid withPath:path];
            }
        }
    }];
    
    }

-(void)updateScore:(NSArray*)poppedLines{
    
    int points = 0;
    for(NSArray* line in poppedLines){
        points += line.count;
    }
    points *= poppedLines.count;
    self.score += points;
    if(self.delegate)
        [self.delegate didUpdateScore:self.score];
}

-(void)didSelectBall:(KKKBall *)ball{
    self.selectedBall = ball;
}

-(void)didDeselectBall:(KKKBall *)ball{
    self.selectedBall = nil;
}

-(void)didMoveBall:(KKKBall *)ball toGridPoint:(CGPoint)gridPoint{
    
    int ox = ball.gridPoint.x;
    int oy = ball.gridPoint.y;
    self.board[ox][oy] = [NSNull null];
    
    [self.freeX addObject:[NSNumber numberWithInt:ox]];
    [self.freeY addObject:[NSNumber numberWithInt:oy]];
    
    for(int i = 0; i < self.freeX.count; i++){
        if([self.freeX[i] integerValue] == gridPoint.x &&
           [self.freeY[i] integerValue] == gridPoint.y)
        {
            [self.freeX removeObjectAtIndex:i];
            [self.freeY removeObjectAtIndex:i];
            break;
        }
    }
    
    ball.gridPoint = gridPoint;
    ball.position = [self CGPointForGridPoint:gridPoint];
    self.board[(int)gridPoint.x][(int)gridPoint.y] = ball;
    
    NSMutableArray *lines = [self getLinesToPopIncludingBall:ball];
    [self.selectedBall deselect];
    
    if(!lines.count){
        [self addNewBalls];
        if(!self.freeX)
            [self.delegate didEndGame];
    }
    
    [self updateScore:lines];
    
    for(NSMutableArray *line in lines)
        for(KKKBall *ball in line)
            [ball remove];
    
}

-(void)didRemoveBall:(KKKBall *)ball{
    
    if( [[self.board[(int)ball.gridPoint.x][(int)ball.gridPoint.y] class] isSubclassOfClass:[KKKBall class]]){
        
        self.board[(int)ball.gridPoint.x][(int)ball.gridPoint.y] = [NSNull null];
        [self.freeX addObject:[NSNumber numberWithInt:ball.gridPoint.x]];
        [self.freeY addObject:[NSNumber numberWithInt:ball.gridPoint.y]];
    }
}



-(CGPoint)gridPointForCGPoint:(CGPoint)point{
    
    CGFloat tileWidth = self.frame.size.width/9;
    CGFloat tileHeight = self.frame.size.height/9;
    int x = 4 + (int)(point.x+tileWidth/2)/tileWidth;
    int y = 4 - (int)(point.y-tileHeight/2)/tileHeight;

    return CGPointMake(x, y);
}

-(CGPoint)CGPointForGridPoint:(CGPoint)gridPoint{
    
    CGFloat tileWidth = self.frame.size.width/9;
    CGFloat tileHeight = self.frame.size.height/9;
    CGFloat x = (gridPoint.x-4)*tileWidth;
    CGFloat y = -(gridPoint.y-4)*tileHeight;
    
    return CGPointMake(x, y);
}




@end
