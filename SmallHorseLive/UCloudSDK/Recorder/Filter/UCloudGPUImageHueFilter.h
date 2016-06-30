
#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageHueFilter : UCloudGPUImageFilter
{
    GLint hueAdjustUniform;
    
}
@property (nonatomic, readwrite) CGFloat hue;

@end
