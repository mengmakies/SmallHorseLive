//
//  UCloudFilterManager.h
//  UCloudMediaRecorderDemo
//
//  Created by yisanmao on 16/1/27.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "UCloudGPUImage.h"

@interface FilterManager : NSObject
/**
 *  调整滤镜参数
 *
 *  @param name  滤镜名字
 *  @param value 值
 */
- (void)valueChange:(NSString *)name value:(float)value;
/**
 *  构建支持的滤镜(不支持返回空)
 *
 *  @return 滤镜
 */
- (NSArray *)filters;
/**
 *  滤镜对应的pickerView，和所支持的滤镜对应
 *
 *  @return data
 */
- (NSMutableArray *)buildData;
/**
 *  设置默认值
 *
 *  @param filters 滤镜
 */
- (void)setCurrentValue:(NSArray *)filters;
@end
