//
//  UCloudLoadingView.h
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/27.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCloudLoadingView : UIView
- (void)show;
- (void)stop;
@end


@interface UCloudView : UIView
//default is 1.0f
@property (nonatomic, assign) CGFloat lineWidth;

//default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, readonly) BOOL isAnimating;

//use this to init
- (id)initWithFrame:(CGRect)frame;

- (void)startAnimation;
- (void)stopAnimation;
@end
