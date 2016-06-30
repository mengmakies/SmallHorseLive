#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageMonochromeFilter : UCloudGPUImageFilter
{
    GLint intensityUniform, filterColorUniform;
}

@property(readwrite, nonatomic) CGFloat intensity;
@property(readwrite, nonatomic) UCloudGPUVector4 color;

- (void)setColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;

@end
