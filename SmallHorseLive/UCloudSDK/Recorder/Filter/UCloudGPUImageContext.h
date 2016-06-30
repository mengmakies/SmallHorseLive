#import "UCloudGLProgram.h"
#import "UCloudGPUImageFramebuffer.h"
#import "UCloudGPUImageFramebufferCache.h"

#define UCloudGPUImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kUCloudGPUImageRotateLeft || (rotation) == kUCloudGPUImageRotateRight || (rotation) == kUCloudGPUImageRotateRightFlipVertical || (rotation) == kUCloudGPUImageRotateRightFlipHorizontal)

typedef enum { kUCloudGPUImageNoRotation, kUCloudGPUImageRotateLeft, kUCloudGPUImageRotateRight, kUCloudGPUImageFlipVertical, kUCloudGPUImageFlipHorizonal, kUCloudGPUImageRotateRightFlipVertical, kUCloudGPUImageRotateRightFlipHorizontal, kUCloudGPUImageRotate180 } UCloudGPUImageRotationMode;

@interface UCloudGPUImageContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) UCloudGLProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) UCloudGPUImageFramebufferCache *framebufferCache;

+ (void *)contextKey;
+ (UCloudGPUImageContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (UCloudGPUImageFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(UCloudGLProgram *)shaderProgram;
- (void)setContextShaderProgram:(UCloudGLProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (UCloudGLProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;

@end

@protocol UCloudGPUImageInput <NSObject>
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (void)setInputFramebuffer:(UCloudGPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(UCloudGPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
