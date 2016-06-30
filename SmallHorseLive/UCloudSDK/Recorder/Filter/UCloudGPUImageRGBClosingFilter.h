#import "UCloudGPUImageFilterGroup.h"

@class UCloudGPUImageRGBErosionFilter;
@class UCloudGPUImageRGBDilationFilter;

// A filter that first performs a dilation on each color channel of an image, followed by an erosion of the same radius. 
// This helps to filter out smaller dark elements.

@interface UCloudGPUImageRGBClosingFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageRGBErosionFilter *erosionFilter;
    UCloudGPUImageRGBDilationFilter *dilationFilter;
}

- (id)initWithRadius:(NSUInteger)radius;


@end
