//
//  YzdHUDImageView.m
//  YzdHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "YzdHUDImageView.h"

static YzdHUDImageView *_shareHUDView = nil;
@implementation YzdHUDImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(YzdHUDImageView *)shareHUDView{
    if (!_shareHUDView) {
        _shareHUDView = [[YzdHUDImageView alloc] init];
        _shareHUDView.alpha = 0;
    }
    return _shareHUDView;
}


@end
