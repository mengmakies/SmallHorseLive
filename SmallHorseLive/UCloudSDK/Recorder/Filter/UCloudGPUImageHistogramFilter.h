#import "UCloudGPUImageFilter.h"

typedef enum { kUCloudGPUImageHistogramRed, kUCloudGPUImageHistogramGreen, kUCloudGPUImageHistogramBlue, kUCloudGPUImageHistogramRGB, kUCloudGPUImageHistogramLuminance} UCloudGPUImageHistogramType;

@interface UCloudGPUImageHistogramFilter : UCloudGPUImageFilter
{
    UCloudGPUImageHistogramType histogramType;
    
    GLubyte *vertexSamplingCoordinates;
    
    UCloudGLProgram *secondFilterProgram, *thirdFilterProgram;
    GLint secondFilterPositionAttribute, thirdFilterPositionAttribute;
}

// Rather than sampling every pixel, this dictates what fraction of the image is sampled. By default, this is 16 with a minimum of 1.
@property(readwrite, nonatomic) NSUInteger downsamplingFactor;

// Initialization and teardown
- (id)initWithHistogramType:(UCloudGPUImageHistogramType)newHistogramType;
- (void)initializeSecondaryAttributes;

@end
