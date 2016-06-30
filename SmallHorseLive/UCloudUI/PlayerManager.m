//
//  PlayerManager.m
//  UCloudMediaRecorderDemo
//
//  Created by yisanmao on 16/1/4.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "PlayerManager.h"
#import "UIWindow+YzdHUD.h"
#import "ViewController.h"

#define UISCREEN_WIDTH      MIN([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height)
#define UISCREEN_HEIGHT     MAX([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height)

#define AlertViewNOBai 100
#define AlertViewSave 101
#define AlertViewSaveSucess 102
#define AlertViewPlayerError 103

@interface PlayerManager()<UCloudPlayerUIDelegate>

@property (strong, nonatomic) NSArray *contrants;

@end

@implementation PlayerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNotification];
    }
    return self;
}

- (void)buildMediaPlayer:(NSString *)path
{
    path = PlayDomain(path);
    /*
    //老版本的初始化播放方式
    NSURL *theMovieURL = [NSURL URLWithString:path];
    self.mediaPlayer = [[UCloudMediaPlayer alloc] init];
    self.mediaPlayer.urlType = UrlTypeAuto;
    [self.mediaPlayer setUrl:theMovieURL];
    
    __weak PlayerManager *weakSelf = self;
    [self.mediaPlayer showInview:self.view definition:^(NSInteger defaultNum, NSArray *data) {
        if (self.mediaPlayer) {
            [weakSelf buildMediaControl:defaultNum data:data];
            [weakSelf configurePlayer];
        }

    }];
    */
    
    __weak PlayerManager *weakSelf = self;
    //新版的初始化播放方式
    //多个实例播放器模式
    //self.mediaPlayer = [[UCloudMediaPlayer alloc] init];
    //单例模式
    self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
    [self.mediaPlayer showMediaPlayer:path urltype:UrlTypeAuto frame:CGRectNull view:self.view completion:^(NSInteger defaultNum, NSArray *data) {
        if (self.mediaPlayer) {
            [weakSelf buildMediaControl:defaultNum data:data];
            //去掉UI
            //[weakSelf configurePlayer];
        }
    }];
}


- (void)buildMediaControl:(NSInteger)defaultNum data:(NSArray *)data
{
    UCloudMediaViewController *vc = [[UCloudMediaViewController alloc] initWithNibName:@"UCloudMediaViewController" bundle:nil];
    self.controlVC = vc;
    self.controlVC.center = self.view.center;
    self.controlVC.center = CGPointMake(100, 100);
    
    self.controlVC.defultQingXiDu = defaultNum;
    if (self.mediaPlayer.defaultDecodeMethod == DecodeMthodHard)
    {
        self.controlVC.defultJieMaQi = 0;
    }
    else if (self.mediaPlayer.defaultDecodeMethod == DecodeMthodSoft)
    {
        self.controlVC.defultJieMaQi = 1;
    }
    self.controlVC.urlType = self.mediaPlayer.urlType;
    
    self.controlVC.defultHuaFu = 2;
    self.mediaPlayer.player.scalingMode = MPMovieScalingModeAspectFill;
    
    self.controlVC.fileName = @"Test";
    self.controlVC.movieInfos = data;
    self.controlVC.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.controlVC.delegateAction = self;
    self.controlVC.delegatePlayer = self.mediaPlayer.player;
}

- (void)configurePlayer
{
    //点播默认是横屏播放，直播进来默认是竖屏播放
    if (self.mediaPlayer.urlType == UrlTypeLive)
    {
        self.isFullscreen = YES;
    }
    [self clickFull:nil];
    
    self.isPortrait = NO;
    
    self.controlVC.view.autoresizingMask = UIViewAutoresizingNone;
    
    
    NSMutableArray *cons = [NSMutableArray array];
    self.p = [NSMutableArray array];
    self.l = [NSMutableArray array];
    
    //当返回defaultNum为ErrorNumCgiMovieCannotFound时，并没有创建出videoView
    if (self.mediaPlayer.player) {
        [self addConstraintForView:self.mediaPlayer.player.view inView:self.view constraint:cons p:self.p l:self.l];
    }
    
    self.playerContraints = [NSArray arrayWithArray:cons];
    self.vcBottomConstraint = [self addConstraintForView:self.controlVC.view inView:self.view constraint:nil];
    
    if (self.mediaPlayer.urlType == UrlTypeLive)
    {
        //生成新的ijksdlView默认旋转角度
        [[NSNotificationCenter defaultCenter] postNotificationName:UCloudPlayerVideoChangeRotationNotification object:@(0)];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view" object:nil];
}

- (void)addConstraintForView:(UIView *)subView inView:(UIView *)view constraint:(NSMutableArray *)contraints p:(NSMutableArray *)p l:(NSMutableArray *)l
{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // center subView horizontally in view
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // center subView vertically in view
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // width subView equal in view
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // height subView equal in view
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    //width subView equal view height
    NSLayoutConstraint *contraint5 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // height subview equal view width
    NSLayoutConstraint *contraint6 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, contraint5, contraint6, nil];
    
    if (contraints)
    {
        [contraints addObjectsFromArray:array];
    }
    if (p)
    {
        [p addObjectsFromArray:@[contraint3, contraint4]];
    }
    if (l)
    {
        [l addObjectsFromArray:@[contraint5, contraint6]];
    }
    
    //把约束添加到父视图上
    [view addConstraints:array];
    
    self.contrants = @[ contraint5,contraint6];
    [view removeConstraints:self.contrants];
    
    
    
//    [NSLayoutConstraint deactivateConstraints:@[contraint5, contraint6]];
    
    
    
    
    self.playerCenterXContraint = contraint2;
    self.playerHeightContraint = contraint4;
}

- (NSLayoutConstraint *)addConstraintForView:(UIView *)subView inView:(UIView *)view constraint:(NSMutableArray *)contraints
{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // align subView and view to top
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // align subView and view to left
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    // align subView and view to bottom
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-0.0];
    //子view的右边缘离父view的右边缘40个像素
    // align subView and view to right
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:-0.0];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    
    if (contraints)
    {
        [contraints addObjectsFromArray:array];
    }
    [view addConstraints:array];
    
    return contraint3;
}

- (void)reConfigurePlayer:(CGFloat)current
{
    float height = self.playerHeightContraint.constant;
    float centerX = self.playerCenterXContraint.constant;
    [self.view removeConstraints:@[self.playerCenterXContraint, self.playerHeightContraint]];
    
    self.controlVC.delegatePlayer = self.mediaPlayer.player;
    
    self.mediaPlayer.player.view.frame = self.controlVC.view.bounds;
    [self.view addSubview:self.mediaPlayer.player.view];
    
    
    NSMutableArray *cons = [NSMutableArray array];
    self.p = [NSMutableArray array];
    self.l = [NSMutableArray array];
    [self addConstraintForView:self.mediaPlayer.player.view inView:self.view constraint:cons p:self.p l:self.l];
    self.playerHeightContraint.constant = height;
    self.playerCenterXContraint.constant = centerX;
    self.playerContraints = [NSArray arrayWithArray:cons];
    
    if (self.mediaPlayer.urlType == UrlTypeLive)
    {
        //生成新的ijksdlView默认旋转角度
        [[NSNotificationCenter defaultCenter] postNotificationName:UCloudPlayerVideoChangeRotationNotification object:@(0)];
    }
    
    self.isPrepared = NO;
    
    [self.view bringSubviewToFront:self.controlVC.view];
    [self.controlVC setRightPanelHidden:YES];
}




#pragma mark - 屏幕旋转
- (void)awakeSupportInterOrtation:(UIViewController *)showVC completion:(void(^)(void))block
{
    UIViewController *vc = [[UIViewController alloc] init];
    void(^completion)() = ^() {
        [showVC dismissViewControllerAnimated:NO completion:nil];
        
        if (block)
        {
            block();
        }
    };
    
    // This check is needed if you need to support iOS version older than 7.0
    BOOL canUseTransitionCoordinator = [showVC respondsToSelector:@selector(transitionCoordinator)];
    BOOL animated = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
    {
        animated = NO;
    }
    else
    {
        animated = YES;
    }
    if (canUseTransitionCoordinator)
    {
        [showVC presentViewController:vc animated:animated completion:nil];
        [showVC.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            completion();
        }];
    }
    else
    {
        [showVC presentViewController:vc animated:NO completion:completion];
    }
}
//屏幕方向改变
-(void)deviceOrientationChanged:(UIInterfaceOrientation)interfaceOrientation
{
    [self.controlVC setRightPanelHidden:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        {
            [self turnToPortraint:^{
                
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [self turnToLeft:^{
                
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            [self turnToRight:^{
                
            }];
        }
            break;
        default:
            break;
    }
    
    BOOL shouldChangeFrame = NO;
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(self.currentOrientation)) || (UIInterfaceOrientationIsPortrait(interfaceOrientation) && UIInterfaceOrientationIsLandscape(self.currentOrientation)))
    {
        shouldChangeFrame = YES;
    }
    
    //调整缓冲提示的位置
    if (shouldChangeFrame)
    {
        [self.controlVC.view.window changeFrame:interfaceOrientation];
    }
    
    //重绘画面
    [self.mediaPlayer refreshView];
}

- (void)rotateBegain:(UIInterfaceOrientation)noti
{
    [self deviceOrientationChanged:noti];
}

- (void)rotateEnd
{
    //重绘画面
    [self.mediaPlayer refreshView];
    [self.controlVC setRightPanelHidden:NO];
    
    [self.controlVC refreshProgressView];
}

-(void)turnToPortraint:(void(^)(void))block
{
    //    _playerBottomContraint.constant = -(UISCREEN_HEIGHT - UISCREEN_WIDTH);
    
    _playerHeightContraint.constant = -[self getContraintConstant];
    _playerCenterXContraint.constant = -[self getContraintConstant]/2.f;
    
    
    _vcBottomConstraint.constant = -[self getContraintConstant];
    _danmuBottomContraint.constant = -[self getContraintConstant];
    
//    self.playerHeightContraint.constant = -(UISCREEN_HEIGHT - UISCREEN_WIDTH);
//    self.playerCenterXContraint.constant = -(UISCREEN_HEIGHT - UISCREEN_WIDTH)/2.f;
//    
//    self.vcBottomConstraint.constant = -(UISCREEN_HEIGHT - UISCREEN_WIDTH);
//    self.danmuBottomContraint.constant = -(UISCREEN_HEIGHT - UISCREEN_WIDTH);
    [self.mediaPlayer refreshView];
    self.isFullscreen = NO;
    
    [self.controlVC hideMenu];
    if (block)
    {
        block();
    }
}

-(void)turnToLeft:(void(^)(void))block
{
    //    _playerBottomContraint.constant = -0.0;
    self.playerCenterXContraint.constant = 0.0;
    self.playerHeightContraint.constant = 0.0;
    
    
    self.vcBottomConstraint.constant = -0.0;
    self.danmuBottomContraint.constant = -0.0;
    [self.mediaPlayer refreshView];
    self.isFullscreen = YES;
    if (block)
    {
        block();
    }
}

-(void)turnToRight:(void(^)(void))block
{
    //    _playerBottomContraint.constant = -0.0;
    self.playerCenterXContraint.constant = 0.0;
    self.playerHeightContraint.constant = 0.0;
    
    self.vcBottomConstraint.constant = -0.0;
    self.danmuBottomContraint.constant = -0.0;
    [self.mediaPlayer refreshView];
    self.isFullscreen = YES;
    if (block)
    {
        block();
    }
}

-(float)getContraintConstant
{
    float delta = UISCREEN_HEIGHT - self.portraitViewHeight;
    
    if (delta < 0)
    {
        delta = 0;
    }
    else if (delta >= UISCREEN_HEIGHT)
    {
        delta = UISCREEN_HEIGHT - UISCREEN_WIDTH;
    }
    return delta;
}

-(UIInterfaceOrientationMask)supportInterOrtation
{
    if (self.supportAutomaticRotation)
    {
        return _supportInterOrtation;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)setSupportAutomaticRotation:(BOOL)supportAutomaticRotation
{
    _supportAutomaticRotation = supportAutomaticRotation;
    if (_supportAutomaticRotation)
    {
        [self.controlVC setFullBtnState:NO];
    }
    else
    {
        [self.controlVC setFullBtnState:YES];
    }
}

#pragma mark - save pic
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = AlertViewSaveSucess;
    [alert show];
}
static bool showing = NO;
#pragma mark - loading view
- (void)showLoadingView
{
    if (!showing)
    {
        showing = YES;
        
        CGAffineTransform trans = self.view.transform;
        
        [self.controlVC.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:NO transForm:trans];
    }
}

- (void)hideLoadingView
{
    showing = NO;
    CGAffineTransform trans = self.view.transform;
    [self.controlVC.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES transForm:trans];
}

#pragma mark - notification
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerBufferingUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateEnd) name:UCloudViewControllerDidRotate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateBegain:) name:UCloudViewControllerWillRotate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerVideoChangeRotationNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerBufferingUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudViewControllerDidRotate object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudViewControllerWillRotate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerVideoChangeRotationNotification object:nil];
}

- (void)noti:(NSNotification *)noti
{
    NSLog(@"%@", noti.name);
    if ([noti.name isEqualToString:UCloudPlaybackIsPreparedToPlayDidChangeNotification])
    {
        [self.controlVC refreshMediaControl];
        
        if (self.current != 0)
        {
            [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
            self.current = 0;
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerLoadStateDidChangeNotification])
    {
        if ([self.mediaPlayer.player loadState] == MPMovieLoadStateStalled)
        {
            //网速不好，开始缓冲
            [self showLoadingView];
        }
        else if ([self.mediaPlayer.player loadState] == (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK))
        {
            //缓冲完毕
            [self hideLoadingView];
        }
    }
    else if ([noti.name isEqualToString:UCloudMoviePlayerSeekCompleted])
    {
        
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackStateDidChangeNotification])
    {
        NSLog(@"backState:%ld", (long)[self.mediaPlayer.player playbackState]);
        if (!self.isPrepared)
        {
            self.isPrepared = YES;
            [self.mediaPlayer.player play];
            
            if (![self.mediaPlayer.player isPlaying])
            {
                [self.controlVC refreshCenterState];
            }
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackDidFinishNotification])
    {
        MPMovieFinishReason reson = [[noti.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (reson == MPMovieFinishReasonPlaybackEnded)
        {
            [self.controlVC stop];
        }
        else if (reson == MPMovieFinishReasonPlaybackError)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"视频播放错误" delegate:self cancelButtonTitle:@"知道了"   otherButtonTitles: nil, nil];
            alert.tag = AlertViewPlayerError;
            [alert show];
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerVideoChangeRotationNotification]&& self.supportAngleChange)
    {
        NSInteger rotation = [noti.object integerValue];
        self.mediaPlayer.player.view.transform = CGAffineTransformIdentity;
        float height = self.playerHeightContraint.constant;
        
        switch (rotation)
        {
            case 0:
            {
//                [NSLayoutConstraint deactivateConstraints:self.p];
                
                [self.view removeConstraints:self.l];
                
//                [NSLayoutConstraint activateConstraints:self.l];
                
                [self.view addConstraints:self.p];
                
                self.playerHeightContraint.constant=_portraitViewHeight;
                self.playerHeightContraint = [self.p firstObject];
                self.mediaPlayer.player.view.transform = CGAffineTransformIdentity;
            }
                break;
            case 90:
            {
//                [NSLayoutConstraint deactivateConstraints:self.l];
                
                [self.view removeConstraints:self.p];
                
//                [NSLayoutConstraint activateConstraints:self.p];
                
                [self.view addConstraints:self.l];
                
                self.playerHeightContraint = [self.l lastObject];
                self.mediaPlayer.player.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }
                break;
            case 180:
            {
//                [NSLayoutConstraint deactivateConstraints:self.p];
                
                
                [self.view removeConstraints:self.l];
                
//                [NSLayoutConstraint activateConstraints:self.l];
                
                
                [self.view addConstraints:self.p];
                
                
                self.playerHeightContraint = [self.p firstObject];
                self.mediaPlayer.player.view.transform = CGAffineTransformMakeRotation(-M_PI);
            }
                break;
            case 270:
            {
//                [NSLayoutConstraint deactivateConstraints:self.l];
                
                
                [self.view removeConstraints:self.p];
                
//                [NSLayoutConstraint activateConstraints:self.p];
                
                [self.view addConstraints:self.l];
                
                self.playerHeightContraint = [self.l lastObject];
                self.mediaPlayer.player.view.transform = CGAffineTransformMakeRotation(-(M_PI+M_PI_2));
            }
                break;
            default:
                break;
        }
        self.playerHeightContraint.constant = height;
        [self.mediaPlayer.player.view updateConstraintsIfNeeded];
    }
}


- (void)dealloc
{
    [self removeNotification];
}

#pragma mark - mediaControl delegate
- (void)onClickMediaControl:(id)sender
{
    
}

- (void)onClickBack:(UIButton *)sender
{
    [self.mediaPlayer.player.view removeFromSuperview];
    [self.controlVC.view removeFromSuperview];
    [self.mediaPlayer.player shutdown];

    self.mediaPlayer = nil;
    
    {
        self.supportInterOrtation = UIInterfaceOrientationMaskPortrait;
        [self awakeSupportInterOrtation:self.viewContorller completion:^{
            self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UCloudMoviePlayerClickBack object:self];
}

- (void)onClickPlay:(id)sender
{
    [self.mediaPlayer.player play];
}

- (void)onClickPause:(id)sender
{
    [self.mediaPlayer.player pause];
}

- (void)durationSliderTouchBegan:(id)delta
{
    //        [self.player pause];
}

- (void)durationSliderTouchEnded:(id)delta
{
    CGFloat del = self.mediaPlayer.player.duration * [delta floatValue];
    del = self.mediaPlayer.player.currentPlaybackTime + del;
    [self.mediaPlayer.player setCurrentPlaybackTime:floor(del)];
    [self.mediaPlayer.player prepareToPlay];
}

- (void)durationSliderValueChanged:(id)delta
{
    
}

- (void)clickBright:(id)sender
{
    
}

- (void)clickVolume:(id)sender
{
    
}

- (void)clickShot:(id)sender
{
    self.current = [self.mediaPlayer.player currentPlaybackTime];
    UIImage *image = [self.mediaPlayer.player thumbnailImageAtCurrentTime];
    [self saveImageToPhotos:image];
}

- (void)selectedDecodeMthod:(DecodeMthod)decodeMthod
{
    self.current = [self.mediaPlayer.player currentPlaybackTime];
    [self.mediaPlayer selectDecodeMthod:decodeMthod];
    [self reConfigurePlayer:0];
    [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
}

- (void)selectedDefinition:(Definition)definition
{
    self.current = [self.mediaPlayer.player currentPlaybackTime];
    [self.mediaPlayer selectDefinition:definition];
    [self reConfigurePlayer:0];
    [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
}

- (void)selectedScalingMode:(MPMovieScalingMode)scalingMode
{
    self.mediaPlayer.player.scalingMode = scalingMode;
    [self reConfigurePlayer:0];
}

- (void)clickFull:(UCoudWebBlock)block
{
    [self.mediaPlayer.player pause];
    
    if(!self.isFullscreen)
    {
        UIDeviceOrientation deviceOr = [UIDevice currentDevice].orientation;
        if (deviceOr == UIInterfaceOrientationLandscapeRight)
        {
            self.supportInterOrtation = UIInterfaceOrientationMaskLandscapeRight;
            [self awakeSupportInterOrtation:self.viewContorller completion:^() {
                
                [self turnToRight:^{
                    self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                    [self.mediaPlayer.player play];
                    self.currentOrientation = UIInterfaceOrientationLandscapeRight;
                    //重绘画面
                    [self.mediaPlayer refreshView];
                }];
            }];
        }
        else
        {
            self.supportInterOrtation = UIInterfaceOrientationMaskLandscapeLeft;
            [self awakeSupportInterOrtation:self.viewContorller completion:^() {
                
                [self turnToLeft:^{
                    self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                    [self.mediaPlayer.player play];
                    self.currentOrientation = UIInterfaceOrientationLandscapeLeft;
                    //重绘画面
                    [self.mediaPlayer refreshView];
                }];
            }];
        }
    }
    else
    {
        self.supportInterOrtation = UIInterfaceOrientationMaskPortrait;
        [self awakeSupportInterOrtation:self.viewContorller completion:^() {
            
            [self turnToPortraint:^{
                self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                [self.mediaPlayer.player play];
                
                //重绘画面
                [self.mediaPlayer refreshView];
            }];
            
        }];
    }
}

- (void)clickDanmu:(BOOL)show
{
    
}

- (void)selectedMenu:(NSInteger)menu choi:(NSInteger)choi
{
    NSLog(@"menu:%ld__choi:%ld", (long)menu, (long)choi);
}

- (BOOL)screenState
{
    return self.isFullscreen;
}


@end
