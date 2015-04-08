//
//  GameViewController.m
//  Kulki
//
//  Created by Krzysztof Kapitan on 21.03.2015.
//  Copyright (c) 2015 Krzysztof Kapitan. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"
#import "KLCPopup.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSMutableArray* nextBallImageViews;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nextBallImageViews = [NSMutableArray array];
    for(int i = 110; i <= 112; i++){
        NSValue *value = [NSValue valueWithNonretainedObject:[self.view viewWithTag:i]];
        [self.nextBallImageViews addObject:value];
    }
    
    
    //NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"GameOver" owner:self options:nil];
    //UIView *myView = nibViews[0];
    //NSLog(@"%f %f",myView.frame.size.height,myView.frame.size.width);
    //    myView.frame = CGRectMake(0, 0, 100, 100);
    ///myView.translatesAutoresizingMaskIntoConstraints = NO;
    //KLCPopup *popup = [KLCPopup popupWithContentView:myView];
    //[popup show];
    

    
}

-(void)viewWillLayoutSubviews
{    
    [super viewWillLayoutSubviews];
    
    if([[self.view class] isSubclassOfClass:[SKView class]]){
        SKView *skView = (SKView *)self.view;
        if(!skView.scene){
            
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            //skView.ignoresSiblingOrder = YES;
            
            // Create and configure the scene.
            GameScene *scene = [[GameScene alloc] initWithSize:self.view.bounds.size];
            // MenuScene *scene = [[MenuScene alloc] initWithSize:self.view.bounds.size];
            
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.boardDelegate = self;
            // Present the scene.
            [skView presentScene:scene];
            
        }
    }
    
    
}

-(void)didUpdateScore:(int)newScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",newScore];
}

-(void)didEndGameWithScore:(int)score{
    // GameOverScene *gameOverScene = [GameOverScene sceneWithSize:self.size];
    //[self.view presentScene:gameOverScene];
    
}


-(void)didDrawNewBalls:(NSArray *)balls{
   
    UIImageView *nextBallImageView;
    for(int i = 0; i < self.nextBallImageViews.count; i++){
        nextBallImageView = (UIImageView*)[self.nextBallImageViews[i] nonretainedObjectValue];
        nextBallImageView.image = nil;
    }
  
    for(int i = 0; i < balls.count; i++){
        KKKBall *ball = (KKKBall*)balls[i];
        nextBallImageView = (UIImageView*)[self.nextBallImageViews[i] nonretainedObjectValue];
        nextBallImageView.image = [UIImage imageNamed:ball.name];
        
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
