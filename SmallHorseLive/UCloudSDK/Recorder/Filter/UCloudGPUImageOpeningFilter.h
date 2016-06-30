#import "UCloudGPUImageFilterGroup.h"

@class UCloudGPUImageErosionFilter;
@class UCloudGPUImageDilationFilter;

// A filter that first performs an erosion on the red channel of an image, followed by a dilation of the same radius. 
// This helps to filter out smaller bright elements.

@interface UCloudGPUImageOpeningFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageErosionFilter *erosionFilter;
    UCloudGPUImageDilationFilter *dilationFilter;
}

@property(readwrite, nonatomic) CGFloat verticalTexelSpacing, horizontalTexelSpacing;

- (id)initWithRadius:(NSUInteger)radius;

@end
