#import "UCloudGPUImageOutput.h"

// The bytes passed into this input are not copied or retained, but you are free to deallocate them after they are used by this filter.
// The bytes are uploaded and stored within a texture, so nothing is kept locally.
// The default format for input bytes is UCloudGPUPixelFormatBGRA, unless specified with pixelFormat:
// The default type for input bytes is UCloudGPUPixelTypeUByte, unless specified with pixelType:

typedef enum {
	UCloudGPUPixelFormatBGRA = GL_BGRA,
	UCloudGPUPixelFormatRGBA = GL_RGBA,
	UCloudGPUPixelFormatRGB = GL_RGB,
    UCloudGPUPixelFormatLuminance = GL_LUMINANCE
} UCloudGPUPixelFormat;

typedef enum {
	UCloudGPUPixelTypeUByte = GL_UNSIGNED_BYTE,
	UCloudGPUPixelTypeFloat = GL_FLOAT
} UCloudGPUPixelType;

@interface UCloudGPUImageRawDataInput : UCloudGPUImageOutput
{
    CGSize uploadedImageSize;
	
	dispatch_semaphore_t dataUpdateSemaphore;
}

// Initialization and teardown
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(UCloudGPUPixelFormat)pixelFormat;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(UCloudGPUPixelFormat)pixelFormat type:(UCloudGPUPixelType)pixelType;

/** Input data pixel format
 */
@property (readwrite, nonatomic) UCloudGPUPixelFormat pixelFormat;
@property (readwrite, nonatomic) UCloudGPUPixelType   pixelType;

// Image rendering
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (void)processData;
- (void)processDataForTimestamp:(CMTime)frameTime;
- (CGSize)outputImageSize;

@end
