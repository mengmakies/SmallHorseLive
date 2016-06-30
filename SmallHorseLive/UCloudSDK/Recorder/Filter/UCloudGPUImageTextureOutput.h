#import <Foundation/Foundation.h>
#import "UCloudGPUImageContext.h"

@protocol UCloudGPUImageTextureOutputDelegate;

@interface UCloudGPUImageTextureOutput : NSObject <UCloudGPUImageInput>
{
    UCloudGPUImageFramebuffer *firstInputFramebuffer;
}

@property(readwrite, unsafe_unretained, nonatomic) id<UCloudGPUImageTextureOutputDelegate> delegate;
@property(readonly) GLuint texture;
@property(nonatomic) BOOL enabled;

- (void)doneWithTexture;

@end

@protocol UCloudGPUImageTextureOutputDelegate
- (void)newFrameReadyFromTextureOutput:(UCloudGPUImageTextureOutput *)callbackTextureOutput;
@end
