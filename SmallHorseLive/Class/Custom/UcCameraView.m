//
//  UcCameraView.m
//  ChatDemo-UI3.0
//
//  Created by 江南孤鹜 on 16/6/17.
//  Copyright © 2016年 江南孤鹜. All rights reserved.
//

#import "UcCameraView.h"
#import "FilterManager.h"
#import "sys/utsname.h"
#import "NSString+UCloudCameraCode.h"

@interface UIView (mxcl)
- (UIViewController *)parentViewController;
@end

@implementation UIView (mxcl)
- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}
@end

@interface UcCameraView ()
{
    NSString *_StreamID;
    __weak IBOutlet UIButton *_btnStop;
    BOOL _isload;
    BOOL _isShutDown;
}

@property (assign, nonatomic) BOOL            shouldAutoStarted;
@property (strong, nonatomic) UIView   *videoView;
@property (strong, nonatomic) FilterManager   *filterManager;
@property (strong, nonatomic) NSMutableArray  *filters;
@end

@implementation UcCameraView

- (id)initWithStreamID:(NSString *)streamID
{
    _StreamID = streamID;
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerClickBack object:nil];
    }
    return self;
}

// 开始直播
-(void)startRecord{
    
    self.shouldAutoStarted = YES;
    [self addNoti];
    
    if ([[CameraServer server] lowThan5])
    {
        //5以下支持4：3
        [CameraServer server].height = 640;
        [CameraServer server].width = 480;
    }
    else
    {
        //5以上的支持16：9
        [CameraServer server].height = 640;
        [CameraServer server].width = 360;
    }
    
    [CameraServer server].fps = 15;
    [CameraServer server].supportFilter = YES;
    
    self.filterManager = [[FilterManager alloc] init];
    self.filters = [self.filterManager buildData];
    
    [CameraServer server].secretkey = CGIKey;
    
    //比特率：11.4  4.05 2.05 1.75
    [CameraServer server].bitrate = 3.05;
    
    NSString *path = RecordDomain(_StreamID);
    
    __weak UcCameraView *weakSelf = self;
    
    [[CameraServer server] configureCameraWithOutputUrl:path
                                                 filter:[self.filterManager filters]
                                        messageCallBack:^(UCloudCameraCode code, NSInteger arg1, NSInteger arg2, id data){
                                            
                                            [self handlerCameraCallBackWithCode:code weakSelf:weakSelf];
                                            
                                        }
                                            deviceBlock:^(AVCaptureDevice *dev) {
                                                
                                                [self handlerCameraDeviceBlock:dev weakSelf:weakSelf];
                                                
                                            }cameraData:^CMSampleBufferRef(CMSampleBufferRef buffer) {
                                                /**
                                                 *  若果不需要裸流，不建议在这里执行操作，讲增加额外的功耗
                                                 */
                                                
                                                return nil;
                                            }];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)handlerCameraCallBackWithCode:(UCloudCameraCode)code
                            weakSelf:(__weak UcCameraView *)weakSelf{
    
    switch (code) {
        case UCloudCamera_BUFFER_OVERFLOW:
            
            break;
        case UCloudCamera_SecretkeyNil:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"密钥为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
            
        case UCloudCamera_PreviewOK:
        {
            [self.videoView removeFromSuperview];
            self.videoView = nil;
            [weakSelf startPreview];
        }
            break;
        case UCloudCamera_PublishOk:
        {
            [[CameraServer server] cameraStart];
            [weakSelf.filterManager setCurrentValue:weakSelf.filters];
        }
            break;
            
        case UCloudCamera_Permission:
        {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"相机授权" message:@"没有权限访问您的相机，请在“设置－隐私－相机”中允许使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alterView show];
        }
            break;
        case UCloudCamera_Micphone:
        {
            [[[UIAlertView alloc] initWithTitle:@"麦克风授权" message:@"没有权限访问您的麦克风，请在“设置－隐私－麦克风”中允许使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        }
            break;
            
        default:
            break;
    }
}

-(void)handlerCameraDeviceBlock:(AVCaptureDevice *)dev
                       weakSelf:(__weak UcCameraView *)weakSelf{
    BOOL containISO = NO;
    for (NSDictionary *fil in weakSelf.filters)
    {
        NSString *type = fil[@"type"];
        if ([type isEqualToString:@"ISO"])
        {
            containISO = YES;
        }
    }
    
    if (SysVersion >= 8.f && containISO)
    {
        AVCaptureDeviceFormat *format = dev.activeFormat;
        
        float minISO = format.minISO;
        NSDictionary *iso = [weakSelf.filters lastObject];
        NSMutableDictionary *newIso = [NSMutableDictionary dictionaryWithDictionary:iso];
        newIso[@"min"] = @(minISO);
        newIso[@"max"] = @(200.f);
        newIso[@"current"] = @(57.7);
        [weakSelf.filters replaceObjectAtIndex:[self.filters indexOfObject:iso] withObject:newIso];
    }
}

- (void) startPreview
{
    UIView *cameraView = [[CameraServer server] getCameraView];
    cameraView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cameraView];
    [self sendSubviewToBack:cameraView];
    cameraView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _videoView = cameraView;
}

- (IBAction)onClickStop:(id)sender {
}

-(void)stopRecord{
    
    self.shouldAutoStarted = NO;
    
    __weak UcCameraView *weakSelf = self;
    [[CameraServer server] shutdown:^{
        if (weakSelf.videoView)
        {
            [weakSelf.videoView removeFromSuperview];
        }
        weakSelf.videoView = nil;
    }];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self removeNoti];
}

- (void)addNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudNeedRestart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudNeedRestart object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)noti:(NSNotification *)noti
{
    NSLog(@"noti name :%@",noti.name);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([noti.name isEqualToString:UCloudMoviePlayerClickBack])
    {
        self.playerManager = nil;
    }
    else if ([noti.name isEqualToString:UCloudNeedRestart])
    {
        if (self.shouldAutoStarted)
        {
            NSLog(@"restart");
            [self startRecord];
        }
    }
    else if ([noti.name isEqualToString:UIApplicationDidEnterBackgroundNotification] || [noti.name isEqualToString:UIApplicationWillResignActiveNotification])
    {
        while (!_isShutDown) {
            [[CameraServer server] shutdown:^{
                
            }];
            _isShutDown = YES;
        }
        _isload = NO;
    }
    else if ([noti.name isEqualToString:UIApplicationDidBecomeActiveNotification])
    {
        while (!_isload) {
            
            [self startRecord];
            _isShutDown = NO;
            _isload = YES;
        }
    }
}

// 开始播放
-(void)startPlay{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    self.playerManager = [[PlayerManager alloc] init];
    self.playerManager.view = self;
    self.playerManager.viewContorller = self.parentViewController;
    //        [self.playerManager setSupportAutomaticRotation:YES];
    //        [self.playerManager setSupportAngleChange:YES];
    float height = self.bounds.size.height;
    [self.playerManager setPortraitViewHeight:height];
    [self.playerManager buildMediaPlayer:_StreamID];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerClickBack object:nil];
}

@end
