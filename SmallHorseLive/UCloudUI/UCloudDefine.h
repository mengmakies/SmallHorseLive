//
//  UCloudDefine.h
//  ChatDemo-UI3.0
//
//  Created by 江南孤鹜 on 16/6/17.
//  Copyright © 2016年 江南孤鹜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCloudMediaPlayer.h"
#import "CameraServer.h"
#import "UCloudMediaViewController.h"
#import "PlayerManager.h"

#ifndef UCloudDefine_h
#define UCloudDefine_h

//demo中的推流地址仅供demo测试使用，如果更换推流域名地址，请联系客服或者客户经理索取对应的CGIKey
#define CGIKey @"publish3-key"
#define RecordDomain(id) [NSString stringWithFormat:@"rtmp://publish3.cdn.ucloud.com.cn/ucloud/%@", id];
#define PlayDomain(id) [NSString stringWithFormat:@"rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/%@", id];
#define SysVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#endif /* UCloudDefine_h */
