#import "UCloudGPUImageFilterGroup.h"
#import "UCloudGPUImageLowPassFilter.h"
#import "UCloudGPUImageDifferenceBlendFilter.h"

@interface UCloudGPUImageHighPassFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageLowPassFilter *lowPassFilter;
    UCloudGPUImageDifferenceBlendFilter *differenceBlendFilter;
}

// This controls the degree by which the previous accumulated frames are blended and then subtracted from the current one. This ranges from 0.0 to 1.0, with a default of 0.5.
@property(readwrite, nonatomic) CGFloat filterStrength;

@end
