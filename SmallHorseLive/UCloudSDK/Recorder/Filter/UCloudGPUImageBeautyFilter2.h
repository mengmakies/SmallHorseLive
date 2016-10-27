//
//  UCloudGPUImageBeautyFilter2.h
//  UCloud
//
//  Copyright © 2016年 ucloud.cn. All rights reserved.
//

#import "UCloudGPUImage.h"

@interface UCloudGPUImageBeautyFilter2 : UCloudGPUImageFilterGroup

/**
 *  设置磨皮强度
 *  0-100,默认62.50
 */
@property (nonatomic, assign) CGFloat smooth;

/**
 *  设置亮度
 *  0-100,未修改状态下值为25，25以下可适当减弱户外强光
 */
@property (nonatomic, assign) CGFloat brightness;

/**
 *  设置饱和度
 *  0-100，未修改状态下值为25
 */
@property (nonatomic, assign) CGFloat saturation;

@end
