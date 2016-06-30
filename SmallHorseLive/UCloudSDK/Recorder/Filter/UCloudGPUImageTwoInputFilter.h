#import "UCloudGPUImageFilter.h"

extern NSString *const kUCloudGPUImageTwoInputTextureVertexShaderString;

@interface UCloudGPUImageTwoInputFilter : UCloudGPUImageFilter
{
    UCloudGPUImageFramebuffer *secondInputFramebuffer;

    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    UCloudGPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
