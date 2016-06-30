#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageJFAVoronoiFilter : UCloudGPUImageFilter
{
    GLuint secondFilterOutputTexture;
    GLuint secondFilterFramebuffer;
    
    
    GLint sampleStepUniform;
    GLint sizeUniform;
    NSUInteger numPasses;
    
}

@property (nonatomic, readwrite) CGSize sizeInPixels;

@end