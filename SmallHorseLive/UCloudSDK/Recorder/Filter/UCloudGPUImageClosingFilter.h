#import "UCloudGPUImageFilterGroup.h"

@class UCloudGPUImageErosionFilter;
@class UCloudGPUImageDilationFilter;

// A filter that first performs a dilation on the red channel of an image, followed by an erosion of the same radius. 
// This helps to filter out smaller dark elements.

@interface UCloudGPUImageClosingFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageErosionFilter *erosionFilter;
    UCloudGPUImageDilationFilter *dilationFilter;
}

@property(readwrite, nonatomic) CGFloat verticalTexelSpacing, horizontalTexelSpacing;

- (id)initWithRadius:(NSUInteger)radius;

@end
