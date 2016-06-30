#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImagePerlinNoiseFilter : UCloudGPUImageFilter 
{
    GLint scaleUniform, colorStartUniform, colorFinishUniform;
}

@property (readwrite, nonatomic) UCloudGPUVector4 colorStart;
@property (readwrite, nonatomic) UCloudGPUVector4 colorFinish;

@property (readwrite, nonatomic) float scale;

@end
