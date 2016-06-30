#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UCloudGPUImageFramebuffer.h"

@interface UCloudGPUImageFramebufferCache : NSObject

// Framebuffer management
- (UCloudGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(UCloudGPUTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (UCloudGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(UCloudGPUImageFramebuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(UCloudGPUImageFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(UCloudGPUImageFramebuffer *)framebuffer;

@end
