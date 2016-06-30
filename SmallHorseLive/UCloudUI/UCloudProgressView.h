//
//  UCloudProgressView.h
//  UCloudPlayerDemo
//
//  Created by yisanmao on 15/8/25.
//  Copyright (c) 2015年 yisanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCloudProgressView : UIView
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) NSInteger cornerRadius;
@property (nonatomic,assign) NSInteger borderWidth;

@property (nonatomic,strong) UIColor *noColor;
@property (nonatomic,strong) UIColor *prsColor;
@property (nonatomic) BOOL showCorner;
@property (nonatomic) BOOL isVertical;

- (void)refreshProgress;
@end
