//
//  UCloudFilterManager.m
//  UCloudMediaRecorderDemo
//
//  Created by yisanmao on 16/1/27.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "FilterManager.h"
#import "CameraServer.h"
#import "UCloudGPUImage.h"

#define SysVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface FilterManager()

@property (strong, nonatomic) UCloudGPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) UCloudGPUImageSharpenFilter *sharpenFilter;
@property (strong, nonatomic) UCloudGPUImageBeautyFilter *beautyFilter;
@property (strong, nonatomic) UCloudGPUImageUnsharpMaskFilter *unSharpMaskFilter;
@property (strong, nonatomic) UCloudGPUImageBilateralFilter *bilateralFilter;
@end


@implementation FilterManager
- (NSArray *)filters
{
    if ([[CameraServer server] lowThan5])
    {
        return nil;
    }
    else
    {
        //self.brightnessFilter = [[UCloudGPUImageBrightnessFilter alloc] init];
        //self.unSharpMaskFilter = [[UCloudGPUImageUnsharpMaskFilter alloc] init];
        self.bilateralFilter = [[UCloudGPUImageBilateralFilter alloc] init];
        //self.sharpenFilter = [[UCloudGPUImageSharpenFilter alloc] init];
        self.beautyFilter = [[UCloudGPUImageBeautyFilter alloc] init];
        
        return @[self.beautyFilter, self.bilateralFilter];
    }
}

- (void)setCurrentValue:(NSArray *)filters
{
    for (NSDictionary *filter in filters)
    {
        float current = [[filter objectForKey:@"current"] floatValue];
        NSString *type = [filter objectForKey:@"type"];
        [self valueChange:type value:current];
    }
}

- (void)valueChange:(NSString *)name value:(float)value
{
    if ([name isEqualToString:@"brightnessFilter"])
    {
        [self.brightnessFilter setBrightness:value];
    }
    else if ([name isEqualToString:@"sharpenFilter"])
    {
        [self.sharpenFilter setSharpness:value];
    }
    else if ([name isEqualToString:@"beautyFilter"])
    {
        [self.beautyFilter setBeautyLevel:value];
    }
    else if ([name isEqualToString:@"bilateralFilter"])
    {
        [self.bilateralFilter setDistanceNormalizationFactor:value];
    }
    else if ([name isEqualToString:@"ISO"])
    {
        [[CameraServer server]changeISO:value];
    }
}

- (NSMutableArray *)buildData
{
    NSArray *infos;
    if ([[CameraServer server] lowThan5])
    {
        return nil;
    }
    else
    {
        if (SysVersion >= 8.f)
        {
            infos = @[
//                      @{@"name":@"亮度", @"type":@"brightnessFilter", @"min":@(-1.0), @"max":@(1.0), @"current":@(0.0)},
//                      @{@"name":@"锐化", @"type":@"sharpenFilter", @"min":@(-4.0), @"max":@(4.0), @"current":@(0.0)},
                      @{@"name":@"美颜", @"type":@"bilateralFilter", @"min":@(0.0), @"max":@(20.0), @"current":@(16.5)},
//                      @{@"name":@"ISO", @"type":@"ISO", @"min":@(10.0), @"max":@(200.0), @"current":@(80.0)},
                      ];
        }
        else
        {
            infos = @[
//                      @{@"name":@"亮度", @"type":@"brightnessFilter", @"min":@(-1.0), @"max":@(1.0), @"current":@(0.0)},
//                      @{@"name":@"锐化", @"type":@"sharpenFilter", @"min":@(-4.0), @"max":@(4.0), @"current":@(0.0)},
                      @{@"name":@"美颜", @"type":@"bilateralFilter", @"min":@(0.0), @"max":@(20.0), @"current":@(8.0)},
                      ];
        }
    }
    return [NSMutableArray arrayWithArray:infos];
}
@end
