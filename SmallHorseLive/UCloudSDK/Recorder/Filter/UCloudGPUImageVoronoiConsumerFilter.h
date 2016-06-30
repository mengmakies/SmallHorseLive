#import "UCloudGPUImageTwoInputFilter.h"

@interface UCloudGPUImageVoronoiConsumerFilter : UCloudGPUImageTwoInputFilter 
{
    GLint sizeUniform;
}

@property (nonatomic, readwrite) CGSize sizeInPixels;

@end
