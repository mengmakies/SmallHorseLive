//
//  UIWindow+YzdHUD.h
//  YzdHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 提示框类型
typedef NS_ENUM(NSUInteger, showHUDType) {
    ShowLoading = 0,//加载中
    ShowPhotoYes,//对号
    ShowPhotoNo,//叉子
    ShowDismiss,//删除
};

typedef void (^AnimationBlock)(UIView *animationView);

@interface UIWindow (YzdHUD)

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled;

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime;


-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled transForm:(CGAffineTransform)trans;

-(void)changeFrame:(UIInterfaceOrientation)orinentation;
@end












