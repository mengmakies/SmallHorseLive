#import "UCloudGPUImageThreeInputFilter.h"

extern NSString *const kUCloudGPUImageFourInputTextureVertexShaderString;

@interface UCloudGPUImageFourInputFilter : UCloudGPUImageThreeInputFilter
{
    UCloudGPUImageFramebuffer *fourthInputFramebuffer;

    GLint filterFourthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    UCloudGPUImageRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourthFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;
    BOOL fourthFrameCheckDisabled;
}

- (void)disableFourthFrameCheck;

@end
