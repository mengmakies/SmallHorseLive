#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageColorPackingFilter : UCloudGPUImageFilter
{
    GLint texelWidthUniform, texelHeightUniform;
    
    CGFloat texelWidth, texelHeight;
}

@end
