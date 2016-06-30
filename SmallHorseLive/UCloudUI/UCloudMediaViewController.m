//
//  UCloudMediaViewController.m
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/24.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import "UCloudMediaViewController.h"
#import "UCloudMediaPlayback.h"
#import "UCloudProgressView.h"
#import "UCloudBrightnessView.h"
#import "PlayerManager.h"

typedef NS_ENUM(NSInteger, GesDirection)
{
    Dir_H,
    Dir_V_L,
    Dir_V_R,
};


#define UISCREEN_WIDTH      MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)
#define UISCREEN_HEIGHT     MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)

#define RIGHTPANELTRANSFORM self.rightPanel.frame.size.width*2

//#define DANMU

@interface UCloudMediaViewController ()<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic,strong) IBOutlet UIView *overlayPanel;
@property(nonatomic,strong) IBOutlet UIView *topPanel;
@property(nonatomic,strong) IBOutlet UIView *bottomPanel;
@property (weak, nonatomic) IBOutlet UIView *rightPanel;

@property(nonatomic,strong) IBOutlet UIButton *playButton;
@property(nonatomic,strong) IBOutlet UIButton *pauseButton;

@property (weak,nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak,nonatomic) IBOutlet UILabel *totalDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *centerPlanBtn;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITableView *resultTabelView;
@property (weak, nonatomic) IBOutlet UITableView *choiceTabelView;
//@property (weak, nonatomic) IBOutlet UCloudProgressView *progressPanel;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet UIButton *danmuButton;

@property (strong, nonatomic) NSDictionary *choices;
@property (strong, nonatomic) NSArray *choi;
@property (nonatomic) GesDirection direc;
@property (nonatomic) CGFloat voiceNormal;
@property (nonatomic) CGFloat progressViewNormal;
@property (nonatomic) CGFloat brightNomal;
@property (strong, nonatomic)UCloudBrightnessView *brightnessView;
@property (nonatomic,strong) UCloudProgressView *progressView;

@property (nonatomic) NSInteger selectedChoices;
@property (strong, nonatomic) NSMutableDictionary *selectedResults;
@property (strong, nonatomic) UILabel *waterMarkLabel;
@end

@implementation UCloudMediaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshMediaControl];
    [self buildData];
    [self buildGes];
    [self buildUI];
    self.choiceTabelView.dataSource = self;
    self.choiceTabelView.delegate = self;
    self.choiceTabelView.tableFooterView = [[UIView alloc] init];
    
    self.resultTabelView.dataSource = self;
    self.resultTabelView.delegate = self;
    self.resultTabelView.tableFooterView = [[UIView alloc] init];
    
    //暂时不加水印
    //    [self waterMark];
}

- (void)buildData
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.movieInfos.count];
    for (NSNumber *dic in self.movieInfos)
    {
        Definition type = [dic integerValue];
        NSString *key = nil;
        if (type == Definition_fhd)
        {
            key = @"蓝光";
        }
        else if (type == Definition_shd)
        {
            key = @"超清";
        }
        else if (type == Definition_hd)
        {
            key = @"高清";
        }
        else if (type == Definition_sd)
        {
            key = @"标清";
        }
        
        if (key != nil)
        {
            [arr addObject:key];
        }
    }
    
    self.choi = @[@"清晰度", @"画幅", @"解码器"];
    if (self.urlType == UrlTypeHttp)
    {
        self.choices = @{@"清晰度":arr, @"画幅":@[@"自动",@"原始",@"全屏"], @"解码器":@[@"硬解",@"软解"]};
        self.selectedResults = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@(self.defultQingXiDu), @"1":@(self.defultHuaFu), @"2":@(self.defultJieMaQi)}];
    }
    else if (self.urlType == UrlTypeLive)
    {
        self.choices = @{@"清晰度":arr, @"画幅":@[@"自动",@"原始",@"全屏"], @"解码器":@[@"软解"]};
        self.selectedResults = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@(self.defultQingXiDu), @"1":@(self.defultHuaFu), @"2":@(0)}];
    }
    else if (self.urlType == UrlTypeLocal)
    {
        self.choices = @{@"清晰度":arr, @"画幅":@[@"自动",@"原始",@"全屏"], @"解码器":@[@"硬解",@"软解"]};
        self.selectedResults = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@(self.defultQingXiDu), @"1":@(self.defultHuaFu), @"2":@(self.defultJieMaQi)}];
    }
    
}

- (void)buildGes
{
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:ges];
}

- (void)pan:(UIPanGestureRecognizer *)ges
{
    CGFloat delta = 0.f;
    if (ges.state == UIGestureRecognizerStateBegan)
    {
        self.progressViewNormal = self.progressView.progress;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.voiceNormal = [MPMusicPlayerController applicationMusicPlayer].volume;
#pragma clang diagnostic pop
        self.brightNomal = [UIScreen mainScreen].brightness;
        
        self.rightPanel.transform = CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0);
        self.rightPanel.hidden = NO;
        [self showAndFade];
        
        if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(durationSliderTouchBegan:)])
        {
            [self.delegateAction durationSliderTouchBegan:nil];
        }
        
        CGPoint point = [ges translationInView:self.view];
        if (fabs(point.x) < fabs(point.y))
        {
            point = [ges locationInView:self.view];
            //竖直   音量或者亮度
            if (point.x < self.view.frame.size.width/2.0)
            {
                //左侧
                self.direc = Dir_V_L;
            }
            else
            {
                //右侧
                self.direc = Dir_V_R;
                if (!self.brightnessView)
                {
                    self.brightnessView = [[UCloudBrightnessView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
                    
                    
                    [self.brightnessView setProgress:[UIScreen mainScreen].brightness];
                }
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIView *superView = self.view.superview;
                if (CGAffineTransformEqualToTransform(superView.transform, CGAffineTransformIdentity))
                {
                    self.brightnessView.center = window.center;
                }
                else
                {
                    
                    self.brightnessView.center = self.view.center;
                }
                
                [self.view addSubview:self.brightnessView];
            }
        }
        else
        {
            //水平   进度
            self.direc = Dir_H;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
        }
    }
    else if (ges.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p = [ges translationInView:self.view];
        if (self.direc == Dir_H)
        {
            delta = p.x/self.view.frame.size.width*2;
        }
        else
        {
            delta = -p.y/self.view.frame.size.height*2;
        }
        
        switch (self.direc)
        {
            case Dir_H:
            {
                if (self.urlType != UrlTypeLive)
                {
                    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(durationSliderValueChanged:)])
                    {
                        [self.delegateAction durationSliderValueChanged:@(delta)];
                    }
                    CGFloat value = self.progressViewNormal + delta;
                    if (value >= 0 && value <= 1)
                    {
                        self.progressView.progress = value;
                    }
                }
            }break;
            case Dir_V_R:
            {
                [self.brightnessView setProgress:(self.brightNomal + delta)];
                
                [UIScreen mainScreen].brightness = self.brightNomal + delta;
            }break;
            case Dir_V_L:
            {
//                [MPMusicPlayerController systemMusicPlayer].volume = self.voiceNormal + delta;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [MPMusicPlayerController applicationMusicPlayer].volume = self.voiceNormal + delta;
#pragma clang diagnostic pop
            }break;
            default:
                break;
        }
    }
    else if (ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed)
    {
        __weak UCloudMediaViewController *weakSelf = self;
        [UIView animateWithDuration:0.5f animations:^{
            
            [weakSelf.brightnessView removeFromSuperview];
            
        }];
//        [self.delegatePlayer play];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
        if (!self.overlayPanel.hidden)
        {
            [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
        }
        
        if (self.urlType != UrlTypeLive)
        {
            if (self.direc == Dir_H && self.delegateAction && [self.delegateAction respondsToSelector:@selector(durationSliderTouchEnded:)])
            {
                [self.delegateAction durationSliderTouchEnded:@(self.progressView.progress - self.progressViewNormal)];
            }
        }
    }
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (tableView == self.choiceTabelView)
    {
        count = self.choi.count;
    }
    else
    {
        NSString *key = [self.choi objectAtIndex:self.selectedChoices];
        count = [[self.choices objectForKey:key] count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.choiceTabelView)
    {
        static NSString *cellId1 = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [self.choi objectAtIndex:indexPath.row];
        
        if (self.selectedChoices == indexPath.row)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:64.f/255.f green:116.f/255.f blue:225.f/255.f alpha:1.f];
        }
        else
        {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *cellId1 = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
        }
        
        NSString *key = [self.choi objectAtIndex:self.selectedChoices];
        NSArray *data = [self.choices objectForKey:key];
        cell.textLabel.text = [data objectAtIndex:indexPath.row];
        
        if ([self tableviewSelectedRow:tableView].row == indexPath.row)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:64.f/255.f green:116.f/255.f blue:225.f/255.f alpha:1.f];
        }
        else
        {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.choiceTabelView)
    {
        self.resultLabel.text = [self.choi objectAtIndex:indexPath.row];
        [self.resultTabelView reloadData];
    }
}

- (NSIndexPath *)tableviewSelectedRow:(UITableView *)tableView
{
    if (tableView == self.choiceTabelView)
    {
        return [NSIndexPath indexPathForRow:self.selectedChoices inSection:0];
    }
    else
    {
        NSInteger sele = [[self.selectedResults objectForKey:[NSString stringWithFormat:@"%@", @(self.selectedChoices)]] integerValue];
        return [NSIndexPath indexPathForRow:sele inSection:0];
    }
}

#pragma mark - show or hide
- (void)createProgressView:(CGRect)frame
{
    if (!self.progressView)
    {
        self.progressView = [[UCloudProgressView alloc] initWithFrame:frame];
        self.progressView.progress = 0.0;
        self.progressView.noColor = [UIColor clearColor];
        self.progressView.borderWidth = 0.8f;
        self.progressView.prsColor = [UIColor colorWithRed:64.f/255.f green:116.f/255.f blue:225.f/255.f alpha:1.f];
        self.progressView.backgroundColor = [UIColor blackColor];
        [self.overlayPanel addSubview:self.progressView];
        
        [self addConstraintForView:self.progressView inView:self.overlayPanel constraint:nil];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
        if (!self.overlayPanel.hidden)
        {
            [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
        }
    }
    else
    {
        self.progressView.frame = frame;
    }
    
    if (_urlType == UrlTypeLive)
    {
        self.progressView.hidden = YES;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [self refreshMediaControl];
}

- (void)refreshProgressView
{
    [self.view needsUpdateConstraints];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (self.progressView)
    {
        [self.progressView refreshProgress];
    }
}

- (void)setFullBtnState:(BOOL)hidden
{
    self.fullButton.hidden = hidden;
}

- (void)refreshCenterState
{
    if (![self.delegatePlayer isPlaying])
    {
        centerBug = YES;
    }
    else
    {
        centerBug = NO;
    }
}

static bool centerBug;

- (NSLayoutConstraint *)addConstraintForView:(UIView *)subView inView:(UIView *)view constraint:(NSMutableArray *)contraints
{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-43.0];
    //子view的右边缘离父view的右边缘40个像素
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0.0];
    //把约束添加到父视图上
     NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:5.0];
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    
    if (contraints)
    {
        [contraints addObjectsFromArray:array];
    }
    [view addConstraints:array];
    
    return contraint3;
}

- (void)buildUI
{
    //菜单，开始不显示
    self.rightPanel.transform = CGAffineTransformIdentity;
    self.rightPanel.transform = CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0);
    self.rightPanel.hidden = YES;
    self.centerPlanBtn.hidden = YES;
    self.playButton.hidden = YES;
#ifdef DANMU
    self.danmuButton.hidden = NO;
#else
    self.danmuButton.hidden = YES;
#endif
    
    [self createProgressView:CGRectZero];
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMediaControl:)];
    [self.view addGestureRecognizer:pan];
}

- (void)showNoFade
{
    self.overlayPanel.hidden = NO;
    [self cancelDelayedHide];
    [self refreshMediaControl];
}

- (void)showAndFade
{
    [self showNoFade];
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)hide
{
    self.overlayPanel.hidden = !self.overlayPanel.hidden;
    [self cancelDelayedHide];
}

- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)refreshMediaControl
{
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSTimeInterval position = self.delegatePlayer.currentPlaybackTime;
    
    NSInteger intDuration = duration;
    NSInteger intPosition = position;
    
    if (intPosition > 0 &&   intPosition <= intDuration)
    {
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
        
        CGFloat value = position/(float)duration;
        if (value >= 0 && value <= 1 && self.progressView.progress != value)
        {
            self.progressView.progress = value;
        }
    }
    else
    {
        self.totalDurationLabel.text = @"--:--";
        self.currentTimeLabel.text = @"00:00";
        self.progressView.progress = 0.0f;
    }
    
    
    PlayerManager *vc = (PlayerManager *)self.delegateAction;
    if (vc.mediaPlayer.defaultDecodeMethod == DecodeMthodHard)
    {
        MPMovieLoadState loadState = [self.delegatePlayer loadState];
        MPMoviePlaybackState backState = [self.delegatePlayer playbackState];
#ifdef  DEGUG
        NSLog(@"load:%lu   back:%ld", (unsigned long)loadState, (long)backState);
#endif
        if (backState == MPMoviePlaybackStatePlaying || backState == MPMoviePlaybackStateSeekingBackward || backState == MPMoviePlaybackStateSeekingForward)
        {
            self.centerPlanBtn.hidden = YES;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
        }
        else
        {
            self.centerPlanBtn.hidden = NO;
            self.pauseButton.hidden = YES;
            self.playButton.hidden = NO;
        }
        
        if (loadState&MPMovieLoadStateStalled)
        {
            self.centerPlanBtn.hidden = YES;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
        }
    }
    else
    {
     if ([self.delegatePlayer isPlaying])
        {
            self.centerPlanBtn.hidden = YES;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
        }
        else
        {
            self.centerPlanBtn.hidden = NO;
            self.pauseButton.hidden = YES;
            self.playButton.hidden = NO;
        }
        
        if (centerBug)
        {
            self.centerPlanBtn.hidden = YES;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
        }
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.overlayPanel.hidden)
    {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}

- (void)showOrHideMenu
{
    __weak UCloudMediaViewController *weakSelf = self;
    if (CGAffineTransformEqualToTransform(self.rightPanel.transform, CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0)))
    {
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.rightPanel.transform = CGAffineTransformIdentity;
            weakSelf.rightPanel.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.rightPanel.transform = CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0);
            weakSelf.rightPanel.hidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hideMenu
{
    self.rightPanel.transform = CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0);
    self.rightPanel.hidden = YES;
}

#pragma mark IBAction
- (void)onClickMediaControl:(UITapGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:self.view];
    
    CGRect frame = self.fullButton.frame;
    if (!self.fullButton.hidden && self.rightPanel.hidden)
    {
        if (CGRectGetMinX(frame) <= p.x && (CGRectGetMaxY(frame) >= p.y))
        {
            [self clickFull:nil];
            return;
        }
    }
    BOOL contain =  CGRectContainsPoint(self.rightPanel.frame, p);
    
    if (p.x > self.view.frame.size.width*2/3 || contain)
    {
        if (self.rightPanel.hidden)
        {
            //show menu
            self.overlayPanel.hidden = YES;
            [self cancelDelayedHide];
            
            BOOL isFullScreen = [self.delegateAction screenState];
            
            if (isFullScreen)
            {
                [self showOrHideMenu];
            }
        }
        else
        {
            //点击 menu
            CGPoint new = [self.choiceTabelView convertPoint:p fromView:self.view];
            if (new.x < 0)
            {
                self.rightPanel.hidden = YES;
            }
            NSIndexPath *indexPath = [self.choiceTabelView indexPathForRowAtPoint:new];
            if (indexPath == nil)
            {
                new  = [self.resultTabelView convertPoint:p fromView:self.view];
                indexPath = [self.resultTabelView indexPathForRowAtPoint:new];
                if (indexPath)
                {
                    [self.selectedResults setObject:@(indexPath.row) forKey:[NSString stringWithFormat:@"%@", @(self.selectedChoices)]];
                    
                    static NSInteger lastOne = 0;
                    static NSInteger lastTwo = 0;
                    
                    NSInteger one = self.selectedChoices;
                    NSInteger two = [self tableviewSelectedRow:self.resultTabelView].row;
                    
                    if (lastOne == one && lastTwo == two)
                    {
                        
                    }
                    else
                    {
                        [self selectMenu:one choi:two];
                    }
                    
                    lastOne = one;
                    lastTwo = two;
                    [self showOrHideMenu];
                    [self.resultTabelView reloadData];
                }
            }
            else
            {
                self.selectedChoices = indexPath.row;
                self.resultLabel.text = [self.choi objectAtIndex:indexPath.row];
                [self.resultTabelView reloadData];
                [self.choiceTabelView reloadData];
            }
        }
    }
    else
    {
        if (self.rightPanel.hidden)
        {
            //显示进度条
            [self showAndFade];
        }
        else
        {
            //hide menu
            self.rightPanel.transform = CGAffineTransformMakeTranslation(RIGHTPANELTRANSFORM, 0);
            self.rightPanel.hidden = YES;
            [self showAndFade];
        }
    }
    
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(onClickMediaControl:)])
    {
        [self.delegateAction onClickMediaControl:sender];
    }
}

- (void)selectMenu:(NSInteger)menu choi:(NSInteger)choi
{
    if (menu == 0)
    {
        //清晰度
        Definition def = [[self.movieInfos objectAtIndex:menu] integerValue];
        if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(selectedDefinition:)])
        {
            [self.delegateAction selectedDefinition:def];
        }
    }
    else if (menu == 1)
    {
        MPMovieScalingMode mode = MPMovieScalingModeNone;
        
        //画幅
        if (choi == 0)
        {
            mode = MPMovieScalingModeAspectFit;
        }
        else if (choi == 1)
        {
            mode = MPMovieScalingModeNone;
        }
        else if (choi == 2)
        {
            mode = MPMovieScalingModeAspectFill;
        }
        if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(selectedScalingMode:)])
        {
            [self.delegateAction selectedScalingMode:mode];
        }
    }
    else
    {
        DecodeMthod method;
        //解码器
        if (choi == 0)
        {
            //硬解
            method = DecodeMthodHard;
        }
        else
        {
            //软解
            method = DecodeMthodSoft;
        }
        if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(selectedDecodeMthod:)])
        {
            [self.delegateAction selectedDecodeMthod:method];
        }
    }
}

- (IBAction)onClickBack:(UIButton *)sender
{
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(onClickBack:)])
    {
        [self.delegateAction onClickBack:sender];
    }
}

- (IBAction)onClickPlay:(id)sender
{
    NSLog(@"%s", __func__);
    
    self.centerPlanBtn.hidden = YES;
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(onClickPlay:)] && sender != nil)
    {
        [self.delegateAction onClickPlay:sender];
    }
}

- (IBAction)onClickPause:(id)sender
{
    centerBug = NO;
    self.centerPlanBtn.hidden = NO;
    self.pauseButton.hidden = YES;
    self.playButton.hidden = NO;
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(onClickPause:)] && sender != nil)
    {
        [self.delegateAction onClickPause:sender];
    }
}

- (IBAction)clickBright:(id)sender
{
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(clickBright:)])
    {
        [self.delegateAction clickBright:sender];
    }
}

- (IBAction)clickVolume:(id)sender
{
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(clickVolume:)])
    {
        [self.delegateAction clickVolume:sender];
    }
}

- (IBAction)clickFull:(UIButton *)sender
{
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(clickFull:)])
    {
        [self.delegateAction clickFull:^(WebRes state, id data, NSError *error) {
            
        }];
    }
}

- (IBAction)clickShot:(id)sender
{
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(clickShot:)])
    {
        [self.delegateAction clickShot:sender];
    }
}

- (IBAction)clickDanmu:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resuce" ofType:@"bundle"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    UIButton *btn = sender;
    static BOOL show = NO;
    NSString *imageName = nil;
    if (!show)
    {
        imageName = @"danmu_h";
        show = YES;
    }
    else
    {
        imageName = @"danmu";
        show = NO;
    }
    UIImage *backImage = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        backImage = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else
    {
        NSString *imagePath = [bundle pathForResource:imageName ofType:@"png"];
        backImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    [btn setBackgroundImage:backImage forState:UIControlStateNormal];
    if (self.delegateAction && [self.delegateAction respondsToSelector:@selector(clickDanmu:)])
    {
        [self.delegateAction clickDanmu:show];
    }
}

#pragma mark - 水印
- (void)waterMark
{
    if (!self.waterMarkLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"UCloud";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        self.waterMarkLabel = label;
        [self.view addSubview:label];
    }
    
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    //1.1告诉系统要执行什么动画
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.waterMarkLabel.frame.size.width/2.f, self.waterMarkLabel.frame.size.height/2.f, self.overlayPanel.frame.size.width - self.waterMarkLabel.frame.size.width, self.overlayPanel.frame.size.height - self.waterMarkLabel.frame.size.height)];
    
    keyAnima.path=path.CGPath;
    keyAnima.delegate = self;
    //1.4设置动画执行的时间
    keyAnima.duration=5.0;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //2.添加核心动画
    [self.waterMarkLabel.layer addAnimation:keyAnima forKey:@"wendingding"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self waterMark];
}

#pragma mark - stop
- (void)stop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [self onClickPause:nil];
}

- (void)setRightPanelHidden:(BOOL)hidden
{
    self.rightPanel.hidden = hidden;
}
@end
