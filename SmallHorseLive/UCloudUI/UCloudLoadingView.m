//
//  UCloudLoadingView.m
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/27.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import "UCloudLoadingView.h"

@interface UCloudLoadingView()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UCloudView *cloudView;
@end

@implementation UCloudLoadingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self build];
    }
    return self;
}

- (void)build
{
    self.backgroundColor = [UIColor clearColor];
    self.cloudView = [[UCloudView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    self.cloudView.center = self.center;
    [self addSubview:self.cloudView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.text = @"正在努力加载";
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = self.backgroundColor;
    [self.label sizeToFit];
    
    CGRect frame = self.label.frame;
    frame = CGRectMake(CGRectGetMidX(self.cloudView.frame)-frame.size.width/2.f, CGRectGetMidY(self.cloudView.frame)+frame.size.width/2.f, frame.size.width, frame.size.height);
    self.label.frame = frame;
    [self addSubview:self.label];
    
}

- (void)show
{
    [self.cloudView startAnimation];
}

- (void)stop
{
    [self.cloudView stopAnimation];
}
@end


@interface UCloudView ()

//0.0 - 1.0
@property (nonatomic, assign) CGFloat anglePer;

@property (nonatomic, strong) NSTimer *timer;

@end
#define ANGLE(a) 2*M_PI/360*a
@implementation UCloudView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAnglePer:(CGFloat)anglePer
{
    _anglePer = anglePer;
    [self setNeedsDisplay];
}

- (void)startAnimation
{
    if (self.isAnimating) {
        [self stopAnimation];
        [self.layer removeAllAnimations];
    }
    _isAnimating = YES;
    
    self.anglePer = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f
                                                  target:self
                                                selector:@selector(drawPathAnimation:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation
{
    _isAnimating = NO;
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self stopRotateAnimation];
}

- (void)drawPathAnimation:(NSTimer *)timer
{
    self.anglePer += 0.03f;
    
    if (self.anglePer >= 1) {
        self.anglePer = 1;
        [timer invalidate];
        self.timer = nil;
        [self startRotateAnimation];
    }
}

- (void)startRotateAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    
    [self.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)stopRotateAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.anglePer = 0;
        [self.layer removeAllAnimations];
        self.alpha = 1;
    }];
}

- (void)drawRect:(CGRect)rect
{
    if (self.anglePer <= 0) {
        _anglePer = 0;
    }
    
    CGFloat lineWidth = 1.f;
    UIColor *lineColor = [UIColor whiteColor];
    if (self.lineWidth) {
        lineWidth = self.lineWidth;
    }
    if (self.lineColor) {
        lineColor = self.lineColor;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds),
                    CGRectGetWidth(self.bounds)/2-lineWidth,
                    ANGLE(120), ANGLE(120)+ANGLE(330)*self.anglePer,
                    0);
    CGContextStrokePath(context);
}
@end
