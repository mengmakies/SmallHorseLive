#import "UCloudGPUImageFilterGroup.h"
#import "UCloudGPUImageBuffer.h"
#import "UCloudGPUImageDissolveBlendFilter.h"

@interface UCloudGPUImageLowPassFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageBuffer *bufferFilter;
    UCloudGPUImageDissolveBlendFilter *dissolveBlendFilter;
}

// This controls the degree by which the previous accumulated frames are blended with the current one. This ranges from 0.0 to 1.0, with a default of 0.5.
@property(readwrite, nonatomic) CGFloat filterStrength;

@end
