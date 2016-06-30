#import "UCloudGPUImageTwoInputFilter.h"

extern NSString *const kUCloudGPUImageThreeInputTextureVertexShaderString;

@interface UCloudGPUImageThreeInputFilter : UCloudGPUImageTwoInputFilter
{
    UCloudGPUImageFramebuffer *thirdInputFramebuffer;

    GLint filterThirdTextureCoordinateAttribute;
    GLint filterInputTextureUniform3;
    UCloudGPUImageRotationMode inputRotation3;
    GLuint filterSourceTexture3;
    CMTime thirdFrameTime;
    
    BOOL hasSetSecondTexture, hasReceivedThirdFrame, thirdFrameWasVideo;
    BOOL thirdFrameCheckDisabled;
}

- (void)disableThirdFrameCheck;

@end
