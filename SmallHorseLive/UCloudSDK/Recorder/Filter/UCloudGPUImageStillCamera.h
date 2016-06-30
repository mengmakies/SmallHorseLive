#import "UCloudGPUImageVideoCamera.h"

void UCloudstillImageDataReleaseCallback(void *releaseRefCon, const void *baseAddress);
void UCloudGPUImageCreateResizedSampleBuffer(CVPixelBufferRef cameraFrame, CGSize finalSize, CMSampleBufferRef *sampleBuffer);

@interface UCloudGPUImageStillCamera : UCloudGPUImageVideoCamera

/** The JPEG compression quality to use when capturing a photo as a JPEG.
 */
@property CGFloat jpegCompressionQuality;

// Only reliably set inside the context of the completion handler of one of the capture methods
@property (readonly) NSDictionary *currentCaptureMetadata;

// Photography controls
- (void)capturePhotoAsSampleBufferWithCompletionHandler:(void (^)(CMSampleBufferRef imageSampleBuffer, NSError *error))block;
- (void)capturePhotoAsImageProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))block;
- (void)capturePhotoAsImageProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))block;
- (void)capturePhotoAsJPEGProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)capturePhotoAsJPEGProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)capturePhotoAsPNGProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *processedPNG, NSError *error))block;
- (void)capturePhotoAsPNGProcessedUpToFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(NSData *processedPNG, NSError *error))block;

@end
