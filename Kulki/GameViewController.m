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
#import "KKKGameData.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSMutableArray* nextBallImageViews;

@property (nonatomic) KLCPopup* menuPopup;
@property (nonatomic) KLCPopup* gameOverPopup;

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
            [self presentMenu];
        
        }
    }
    
    
}

-(void)didUpdateScore:(int)newScore{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",newScore];
}

-(void)didEndGameWithScore:(int)score{
    
    if(score > [[KKKGameData sharedGameData] highScore]){
        [[KKKGameData sharedGameData] setHighScore:score];
    }
    
    [self.gameOverPopup show];

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

-(void)presentMenu{
    
    for(NSValue* value in self.nextBallImageViews){
        UIImageView *imageView = (UIImageView*)[value nonretainedObjectValue];
        imageView.image = nil;
    }
    
    self.scoreLabel.text = @"0";
    self.scoreLabel.hidden = YES;
    self.scoreStaticLabel.hidden = YES;
    
    NSArray *menuNibViews = [[NSBundle mainBundle] loadNibNamed:@"GameMenu" owner:self options:nil];
    UIView *menuView = menuNibViews[0];
    UILabel *highScoreLabel = (UILabel*)[menuView viewWithTag:10];
    highScoreLabel.text = [NSString stringWithFormat:@"%d",
                           [[KKKGameData sharedGameData] highScore]];
    
    self.menuPopup = [KLCPopup popupWithContentView:menuView
                                           showType:KLCPopupShowTypeBounceIn
                                        dismissType:KLCPopupDismissTypeBounceOut
                                           maskType:KLCPopupMaskTypeClear
                           dismissOnBackgroundTouch:NO
                              dismissOnContentTouch:NO];
    
    
    
    SKView *skView = (SKView *)self.view;
    
    MenuScene *scene = [[MenuScene alloc] initWithSize:self.view.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    
    [self.menuPopup show];
}

-(void)presentGame{
    
    
    self.scoreLabel.hidden = NO;
    self.scoreStaticLabel.hidden = NO;
   
    NSArray *gameOverNibViews = [[NSBundle mainBundle] loadNibNamed:@"GameOver" owner:self options:nil];
    UIView *gameOverView = gameOverNibViews[0];
    
    self.gameOverPopup = [KLCPopup popupWithContentView:gameOverView
                                               showType:KLCPopupShowTypeBounceIn
                                            dismissType:KLCPopupDismissTypeBounceOut
                                               maskType:KLCPopupMaskTypeClear
                               dismissOnBackgroundTouch:NO
                                  dismissOnContentTouch:NO];
    

    
    SKView *skView = (SKView*)self.view;
    GameScene *scene = [[GameScene alloc] initWithSize:self.view.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.boardDelegate = self;
    // Present the scene.
    [skView presentScene:scene];
}

- (IBAction)mainMenuAction:(id)sender {
    __weak GameViewController* self_ = self;
    self.gameOverPopup.didFinishDismissingCompletion = ^{
        [self_ presentMenu];
    };
    [self.gameOverPopup dismiss:YES];
}

- (IBAction)startGameAction:(id)sender {
    __weak GameViewController* self_ = self;
    
    self.menuPopup.didFinishDismissingCompletion = ^{
        [self_ presentGame];
    };
    [self.menuPopup dismiss:YES];
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
