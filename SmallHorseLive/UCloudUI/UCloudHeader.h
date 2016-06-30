//
//  UCloudHeader.h
//  IJKMediaPlayer
//
//  Created by yisanmao on 15/9/9.
//  Copyright (c) 2015年 bilibili. All rights reserved.
//

#ifndef IJKMediaPlayer_UCloudHeader_h
#define IJKMediaPlayer_UCloudHeader_h

#pragma mark - 宏定义

#endif

#ifdef DEBUG
#define UCloudDebug(...) (NSLog(__VA_ARGS__))
#else
#define UCloudDebug(...) (NSLog(@""))
#endif

#define UCloudLog(...) (NSLog(__VA_ARGS__))


#pragma mark - Url

#define APPBundle @"iOS_1.0"
#define APPVersion @"1.0"

#define KeyChainUUID @"ucloud.uuid"
#define KeyChainPID  @"ucloud.pid"

#define URLCGI    @"http://cgi.video.ucloud.com.cn:80/get_video_info"
#define URLREPORT @"http://report.video.ucloud.com.cn:8080/report"

#define PARM_ADD_STR(dictionary, key, value) if (key != nil && value != nil) { dictionary[key] = value; }
#define PARM_ADD_NUM(dictionary, key, value) if (key != nil) { dictionary[key] = @(value); }

typedef NS_ENUM(NSInteger, WebRes)
{
    WebSucess,
    WebFailure,
};

typedef NS_ENUM(NSInteger, UCloudStep)
{
    StepCount = 1,
    StepTotalTime = 2,
    StepFirstLoadingTime  = 3,
    StepSecondBufferingStart = 4,
    StepSecondBufferingEnd = 5,
    StepError = 6,
};

typedef NS_ENUM(NSInteger, UCloudMovieFrom)
{
    MovieFromUnknown,
    MovieFromUrl,
    MovieFromLocal,
};

typedef NS_ENUM(NSInteger, UCloudStopMovieState)
{
    StopMovieUnknown,
    StopMoviePlayAll,
    StopMovieLoaded,
};

typedef void(^UCoudWebBlock)(WebRes state, id data, NSError *error);




