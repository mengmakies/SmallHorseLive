//
//  GPUImageBeautyFilter.h
//  GPUImage
//
//  Created by yisanmao on 16/2/1.
//  Copyright © 2016年 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageBeautyFilter : UCloudGPUImageFilter
{
    GLint beautyLevelUniform;
    GLint singleUniform;
}
@property (assign, nonatomic) int beautyLevel;
@end
