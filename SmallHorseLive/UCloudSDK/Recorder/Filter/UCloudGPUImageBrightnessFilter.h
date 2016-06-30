#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageBrightnessFilter : UCloudGPUImageFilter
{
    GLint brightnessUniform;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat brightness; 

@end
