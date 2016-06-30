#import "UCloudGPUImagePixellateFilter.h"

@interface UCloudGPUImagePolkaDotFilter : UCloudGPUImagePixellateFilter
{
    GLint dotScalingUniform;
}

@property(readwrite, nonatomic) CGFloat dotScaling;

@end
