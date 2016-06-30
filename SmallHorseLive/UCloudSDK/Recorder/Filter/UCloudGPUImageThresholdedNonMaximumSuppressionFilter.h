#import "UCloudGPUImage3x3TextureSamplingFilter.h"

@interface UCloudGPUImageThresholdedNonMaximumSuppressionFilter : UCloudGPUImage3x3TextureSamplingFilter
{
    GLint thresholdUniform;
}

/** Any local maximum above this threshold will be white, and anything below black. Ranges from 0.0 to 1.0, with 0.8 as the default
 */
@property(readwrite, nonatomic) CGFloat threshold;

- (id)initWithPackedColorspace:(BOOL)inputUsesPackedColorspace;

@end
