//
//  UCloudMediaViewController.h
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/24.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCloudHeader.h"
#import "UCloudMediaPlayer.h"

@protocol UCloudMediaPlayback;

/**
 *  播放器界面事件代理
 */
@protocol UCloudPlayerUIDelegate<NSObject>

- (void)onClickMediaControl:(id)sender;
- (void)onClickBack:(UIButton*)sender;
- (void)onClickPlay:(id)sender;
- (void)onClickPause:(id)sender;

- (void)durationSliderTouchBegan:(id)delta;
- (void)durationSliderTouchEnded:(id)delta;
- (void)durationSliderValueChanged:(id)delta;

- (void)clickBright:(id)sender;
- (void)clickVolume:(id)sender;
- (void)clickShot:(id)sender;

- (void)selectedDecodeMthod:(DecodeMthod)decodeMthod;
- (void)selectedDefinition:(Definition)definition;
- (void)selectedScalingMode:(MPMovieScalingMode)scalingMode;

- (void)clickFull:(UCoudWebBlock)block;
- (BOOL)screenState;
- (void)clickDanmu:(BOOL)show;

@end

@class UCloudMediaPlayer;

@interface UCloudMediaViewController : UIViewController

@property (nonatomic, weak) id<UCloudMediaPlayback> delegatePlayer;
@property (nonatomic, weak) id<UCloudPlayerUIDelegate> delegateAction;
@property (strong, nonatomic) NSArray* movieInfos;
@property (assign, nonatomic) UrlType urlType;
@property (assign, nonatomic) NSInteger defultQingXiDu;

@property (assign, nonatomic) NSInteger defultHuaFu;
@property (assign, nonatomic) NSInteger defultJieMaQi;
@property (strong, nonatomic) NSString* fileName;
@property (assign, nonatomic) CGPoint center;

- (void)showNoFade;
- (void)showAndFade;
- (void)hide;
- (void)hideMenu;
- (void)stop;

- (void)refreshMediaControl;
- (void)refreshProgressView;
- (void)refreshCenterState;

- (void)setRightPanelHidden:(BOOL)hidden;
- (void)setFullBtnState:(BOOL)hidden;

@end
