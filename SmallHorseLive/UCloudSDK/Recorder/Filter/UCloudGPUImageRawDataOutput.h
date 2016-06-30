#import <Foundation/Foundation.h>
#import "UCloudGPUImageContext.h"

struct UCloudGPUByteColorVector {
    GLubyte red;
    GLubyte green;
    GLubyte blue;
    GLubyte alpha;
};
typedef struct UCloudGPUByteColorVector UCloudGPUByteColorVector;

@protocol UCloudGPUImageRawDataProcessor;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
@interface UCloudGPUImageRawDataOutput : NSObject <UCloudGPUImageInput> {
    CGSize imageSize;
    UCloudGPUImageRotationMode inputRotation;
    BOOL outputBGRA;
}
#else
@interface UCloudGPUImageRawDataOutput : NSObject <UCloudGPUImageInput> {
    CGSize imageSize;
    UCloudGPUImageRotationMode inputRotation;
    BOOL outputBGRA;
}
#endif

@property(readonly) GLubyte *rawBytesForImage;
@property(nonatomic, copy) void(^newFrameAvailableBlock)(void);
@property(nonatomic) BOOL enabled;

// Initialization and teardown
- (id)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat;

// Data access
- (UCloudGPUByteColorVector)colorAtLocation:(CGPoint)locationInImage;
- (NSUInteger)bytesPerRowInOutput;

- (void)setImageSize:(CGSize)newImageSize;

- (void)lockFramebufferForReading;
- (void)unlockFramebufferAfterReading;

@end
