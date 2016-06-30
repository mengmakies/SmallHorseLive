//
//  UCloudBrightnessView.m
//  UCloudDemo
//
//  Created by yisanmao on 15/8/31.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import "UCloudBrightnessView.h"

#define COUNT 16

@interface UCloudBrightnessView()
@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UIImageView *oneView;
@end

@implementation UCloudBrightnessView
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
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resuce" ofType:@"bundle"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSBundle *bundle = [NSBundle bundleWithURL:url];
//    
    UIImage *backImage = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        backImage = [UIImage imageNamed:@"brightness_bgiphone.png" inBundle:bundle compatibleWithTraitCollection:nil];
//    }
//    else
//    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"brightness_bgiphone" ofType:@"png"];
        backImage = [UIImage imageWithContentsOfFile:imagePath];
//    }
    
    
    self.backView.image = backImage;
    self.backView.frame = CGRectMake(0, 0, 155, 155);
    [self addSubview:self.backView];
    
    
    CGFloat delta = 1.f;
    CGFloat width = 7.f;
    CGFloat height = 5.f;
    CGFloat begain = 14.f;
    
    for (int i = 0; i < COUNT; i++)
    {
        CGRect frame = CGRectMake(i*(width +delta)+begain, 133.5f, width, height);
        [self build:frame tag:(i+100)];
    }
}

- (void)build:(CGRect)frame tag:(NSInteger)tag
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resuce" ofType:@"bundle"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSBundle *bundle = [NSBundle bundleWithURL:url];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    UIImage *image = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        image = [UIImage imageNamed:@"bright_point.png" inBundle:bundle compatibleWithTraitCollection:nil];
//    }
//    else
//    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"bright_point" ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
//    }
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2.f topCapHeight:image.size.height/2.f];
    imageView.image = image;
    imageView.tag = tag;
    [self addSubview:imageView];
}

- (void)setProgress:(CGFloat)progress
{
    if (progress != _progress)
    {
        _progress = progress;
        
        for (int i = 0; i < COUNT; i++)
        {
            UIView *view = [self viewWithTag:(i+100)];
            if (i< _progress*COUNT)
            {
                view.hidden = NO;
            }
            else
            {
                view.hidden = YES;
            }
        }
        
        
    }
}
@end













