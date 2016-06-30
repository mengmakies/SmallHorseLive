//
//  UCloudProgressView.m
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/25.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import "UCloudProgressView.h"

@interface UCloudProgressView()

@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;

@end

@implementation UCloudProgressView
- (void)awakeFromNib
{
    [self zdInit];
    [self zdFrame:self.frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zdInit];
        [self zdFrame:frame];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self zdFrame:frame];
}

- (void)zdFrame:(CGRect)frame
{
    if (self.showCorner)
    {
        self.layer.cornerRadius = frame.size.height/2;
    }
    
    if (self.isVertical)
    {
        self.oneView.frame = CGRectMake(0, self.frame.size.height*(1-_progress), self.frame.size.width, self.frame.size.height);
    }
    else
    {
        self.oneView.frame = CGRectMake(0, 0, self.frame.size.width * _progress, self.frame.size.height);
    }
    
    if (self.showCorner)
    {
        self.oneView.layer.cornerRadius = frame.size.height/2;
    }
    
    self.twoView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)zdInit
{
    self.borderWidth = 1;
    
    self.twoView = [[UIView alloc] init];
    self.twoView.clipsToBounds = YES;
    [self addSubview:self.twoView];
    
    self.oneView = [[UIView alloc] init];
    self.oneView.clipsToBounds = YES;
    [self addSubview:self.oneView];
}

#pragma property set or get
- (void)setNoColor:(UIColor *)noColor
{
    self.twoView.backgroundColor = noColor;
}

- (void)setPrsColor:(UIColor *)prsColor
{
    self.layer.borderColor = prsColor.CGColor;
    self.oneView.backgroundColor = prsColor;
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress || progress == 0.f)
    {
        if (self.isVertical)
        {
            self.oneView.frame = CGRectMake(0, self.frame.size.height*(1-progress), self.frame.size.width, self.frame.size.height);
        }
        else
        {
            self.oneView.frame = CGRectMake(0, 0, self.frame.size.width * progress, self.frame.size.height);
        }
        _progress = progress;
    }
}

- (void)refreshProgress
{
    if (self.isVertical)
    {
        self.oneView.frame = CGRectMake(0, self.frame.size.height*(1-_progress), self.frame.size.width, self.frame.size.height);
    }
    else
    {
        self.oneView.frame = CGRectMake(0, 0, self.frame.size.width * _progress, self.frame.size.height);
    }
}

- (void)setBorderWidth:(NSInteger)borderWidth
{
    self.layer.borderWidth = borderWidth;
}
@end
