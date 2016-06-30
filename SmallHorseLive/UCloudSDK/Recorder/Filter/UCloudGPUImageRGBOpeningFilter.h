#import "UCloudGPUImageFilterGroup.h"

@class UCloudGPUImageRGBErosionFilter;
@class UCloudGPUImageRGBDilationFilter;

// A filter that first performs an erosion on each color channel of an image, followed by a dilation of the same radius. 
// This helps to filter out smaller bright elements.

@interface UCloudGPUImageRGBOpeningFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageRGBErosionFilter *erosionFilter;
    UCloudGPUImageRGBDilationFilter *dilationFilter;
}

- (id)initWithRadius:(NSUInteger)radius;

@end
