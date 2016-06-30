//
//  UIWindow+YzdHUD.m
//  YzdHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "UIWindow+YzdHUD.h"
#import "YzdHUDBackgroundView.h"
#import "YzdHUDImageView.h"
#import "YzdHUDIndicator.h"
#import "YzdHUDLabel.h"

#define YzdHUDBounds CGRectMake(0, 0, 100, 100)
#define YzdHUDCenter CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
#define YzdHUDBackgroundAlpha 1
#define YzdHUDComeTime 0.15
#define YzdHUDStayTime 1
#define YzdHUDGoTime 0.15
#define YzdHUDFont 17

@implementation UIWindow (YzdHUD)

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled{
    CGFloat time = YzdHUDComeTime;
    if (type != ShowLoading)
    {
        time = 0.01;
    }
    [self showHUDWithText:text Type:type Enabled:(BOOL)enabled Bounds:YzdHUDBounds Center:YzdHUDCenter BackgroundAlpha:YzdHUDBackgroundAlpha ComeTime:time StayTime:time GoTime:time];
}

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled transForm:(CGAffineTransform)trans
{
    CGFloat time = YzdHUDComeTime;
    if (type != ShowLoading)
    {
        time = 0.01;
    }
    
    [self showHUDWithText:text Type:type Enabled:(BOOL)enabled Bounds:YzdHUDBounds Center:YzdHUDCenter BackgroundAlpha:YzdHUDBackgroundAlpha ComeTime:time StayTime:time GoTime:time transForm:trans];
}

- (void)changeFrame:(UIInterfaceOrientation)orinentation
{
    CGPoint center = YzdHUDCenter;
    CGRect bounds = YzdHUDBounds;
   
//    if (orinentation == UIInterfaceOrientationPortrait)
//    {
//         [YzdHUDBackgroundView shareHUDView].center = center;
//        [YzdHUDLabel shareHUDView].center = CGPointMake(center.y+ bounds.size.width/3.5, center.x );
//        [YzdHUDImageView shareHUDView].center = CGPointMake(center.y - bounds.size.width/6, center.x);
//        [YzdHUDIndicator shareHUDView].center = CGPointMake(center.y - bounds.size.width/6, center.x);
//    }
//    else
//    {
        [YzdHUDBackgroundView shareHUDView].center = CGPointMake(center.y, center.x);
        [YzdHUDLabel shareHUDView].center = CGPointMake(center.y , center.x + bounds.size.width/3.5);
        [YzdHUDImageView shareHUDView].center = CGPointMake(center.y , center.x - bounds.size.width/6);
        [YzdHUDIndicator shareHUDView].center = CGPointMake(center.y , center.x - bounds.size.width/6);
//    }
}

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime transForm:(CGAffineTransform)trans
{
    static BOOL isShow = YES;
    isShow = NO;
    UIView *view = [YzdHUDBackgroundView shareHUDView];
    [self addSubview:view];
    view.transform = trans;
    
    view = [YzdHUDImageView shareHUDView];
    [self addSubview:view];
    view.transform = trans;
    
    view = [YzdHUDLabel shareHUDView];
    [self addSubview:view];
    view.transform = trans;
    
    view = [YzdHUDIndicator shareHUDView];
    [self addSubview:view];
    view.transform = trans;
    
    [YzdHUDBackgroundView shareHUDView].center = center;
    if (CGAffineTransformEqualToTransform(trans, CGAffineTransformIdentity))
    {
        [YzdHUDLabel shareHUDView].center = CGPointMake(center.x, center.y + bounds.size.height/3.5);
        [YzdHUDImageView shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
        [YzdHUDIndicator shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
    }
    else
    {
        [YzdHUDLabel shareHUDView].center = CGPointMake(center.x+ bounds.size.width/3.5, center.y );
        [YzdHUDImageView shareHUDView].center = CGPointMake(center.x - bounds.size.width/6, center.y);
        [YzdHUDIndicator shareHUDView].center = CGPointMake(center.x - bounds.size.width/6, center.y);
    }
    [self goTimeBounds:bounds];
    
    [YzdHUDLabel shareHUDView].bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height/2 - 10);
    if ([self textLength:text] * YzdHUDFont + 10 >= bounds.size.width) {
        [YzdHUDLabel shareHUDView].font = [UIFont systemFontOfSize:YzdHUDFont - 2];
    }
    
    self.userInteractionEnabled = enabled;
    
    switch (type) {
        case ShowLoading:
            [self showLoadingWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoYes:
            [self showPhotoYesWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoNo:
            [self showPhotoNoWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowDismiss:
            [self showDismissWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
            
        default:
            break;
    }
}

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    static BOOL isShow = YES;
    if (isShow) {
        isShow = NO;
        [self addSubview:[YzdHUDBackgroundView shareHUDView]];
        [self addSubview:[YzdHUDImageView shareHUDView]];
        [self addSubview:[YzdHUDLabel shareHUDView]];
        [self addSubview:[YzdHUDIndicator shareHUDView]];
        
        [YzdHUDBackgroundView shareHUDView].center = center;
        [YzdHUDLabel shareHUDView].center = CGPointMake(center.x, center.y + bounds.size.height/3.5);
        [YzdHUDImageView shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
        [YzdHUDIndicator shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
        [self goTimeBounds:bounds];
    }
    
    [YzdHUDLabel shareHUDView].bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height/2 - 10);
    if ([self textLength:text] * YzdHUDFont + 10 >= bounds.size.width) {
        [YzdHUDLabel shareHUDView].font = [UIFont systemFontOfSize:YzdHUDFont - 2];
    }
    
    self.userInteractionEnabled = enabled;
    
    switch (type) {
        case ShowLoading:
            [self showLoadingWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoYes:
            [self showPhotoYesWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoNo:
            [self showPhotoNoWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowDismiss:
            [self showDismissWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
            
        default:
            break;
    }
}

-(void)showLoadingWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([YzdHUDBackgroundView shareHUDView].alpha != 0) {
        return;
    }
    
    [YzdHUDLabel shareHUDView].text = text;
    [[YzdHUDIndicator shareHUDView] stopAnimating];
    [YzdHUDImageView shareHUDView].alpha = 0;
    
    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:NO];
        [[YzdHUDIndicator shareHUDView] startAnimating];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showPhotoYesWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[YzdHUDIndicator shareHUDView] isAnimating]) {
        [[YzdHUDIndicator shareHUDView] stopAnimating];
        
        [YzdHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
    }else{
        if ([YzdHUDBackgroundView shareHUDView].alpha != 0) {
            return;
        }
        [self goTimeBounds:bounds];
        [self goTimeInit];
    }
    
    [YzdHUDLabel shareHUDView].text = text;
    [YzdHUDImageView shareHUDView].image = [UIImage imageNamed:@"HUD_YES"];
    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:stayTime animations:^{
            [self stayTimeAlpha:backgroundAlpha];
        } completion:^(BOOL finish) {
            [UIView animateWithDuration:goTime animations:^{
                [self goTimeBounds:bounds];
                [self goTimeInit];;
            } completion:^(BOOL finis) {
                //Nothing
            }];
        }];
    }];
}

-(void)showPhotoNoWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[YzdHUDIndicator shareHUDView] isAnimating]) {
        [[YzdHUDIndicator shareHUDView] stopAnimating];
        
        [YzdHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
    }else{
        if ([YzdHUDBackgroundView shareHUDView].alpha != 0) {
            return;
        }
        [self goTimeBounds:bounds];
        [self goTimeInit];
    }
    
    [YzdHUDLabel shareHUDView].text = text;
    [YzdHUDImageView shareHUDView].image = [UIImage imageNamed:@"HUD_NO"];
    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:stayTime animations:^{
            [self stayTimeAlpha:backgroundAlpha];
        } completion:^(BOOL finish) {
            [UIView animateWithDuration:goTime animations:^{
                [self goTimeBounds:bounds];
                [self goTimeInit];;
            } completion:^(BOOL finis) {
                //Nothing
            }];
        }];
    }];
}

-(void)showDismissWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[YzdHUDIndicator shareHUDView] isAnimating]) {
        [[YzdHUDIndicator shareHUDView] stopAnimating];
    }
    
    [YzdHUDLabel shareHUDView].text = nil;
    [YzdHUDImageView shareHUDView].image = nil;
    [UIView animateWithDuration:goTime animations:^{
        [YzdHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
        [self goTimeBounds:bounds];
        [self goTimeInit];
    } completion:^(BOOL finished) {
        //Nothing
    }];
}

#pragma mark 状态
-(void)goTimeBounds:(CGRect)bounds{
    [YzdHUDBackgroundView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width * 1.5, bounds.size.height * 1.5);
    [YzdHUDImageView shareHUDView].bounds =
    CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
}

-(void)goTimeInit{
    [YzdHUDBackgroundView shareHUDView].alpha = 0;
    [YzdHUDImageView shareHUDView].alpha = 0;
    [YzdHUDLabel shareHUDView].alpha = 0;
    [[YzdHUDIndicator shareHUDView] stopAnimating];
}

-(void)stayTimeAlpha:(CGFloat)alpha{
    [YzdHUDBackgroundView shareHUDView].alpha = alpha - 0.01;
}

-(void)comeTimeBounds:(CGRect)bounds{
    [YzdHUDBackgroundView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    [YzdHUDImageView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width/2.5 - 5, bounds.size.height/2.5 - 5);
}

-(void)comeTimeAlpha:(CGFloat)alpha withImage:(BOOL)isImage{
    [YzdHUDBackgroundView shareHUDView].alpha = alpha;
    [YzdHUDLabel shareHUDView].alpha = 1;
    if (isImage) {
        [YzdHUDImageView shareHUDView].alpha = 1;
    }
}

#pragma mark - 计算字符串长度
- (int)textLength:(NSString *)text{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}
@end
