#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UCloudGPUImageContext.h"

extern NSString *const kUCloudGPUImageColorSwizzlingFragmentShaderString;

@protocol UCloudGPUImageMovieWriterDelegate <NSObject>

@optional
- (void)movieRecordingCompleted;
- (void)movieRecordingFailedWithError:(NSError*)error;
- (void)movieAppendBuffer:(CVPixelBufferRef)buffer time:(CMTime)time;
- (CMTime)getTime;
@end

@interface UCloudGPUImageMovieWriter : NSObject <UCloudGPUImageInput>
{
    BOOL alreadyFinishedRecording;
    
    NSURL *movieURL;
    NSString *fileType;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterAudioInput;
	AVAssetWriterInput *assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferInput;
    
    UCloudGPUImageContext *_movieWriterContext;
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;

    CGSize videoSize;
    UCloudGPUImageRotationMode inputRotation;
}

@property(readwrite, nonatomic) BOOL hasAudioTrack;
@property(readwrite, nonatomic) BOOL shouldPassthroughAudio;
@property(readwrite, nonatomic) BOOL shouldInvalidateAudioSampleWhenDone;
@property(nonatomic, copy) void(^completionBlock)(void);
@property(nonatomic, copy) void(^failureBlock)(NSError*);
@property(nonatomic, assign) id<UCloudGPUImageMovieWriterDelegate> delegate;
@property(readwrite, nonatomic) BOOL encodingLiveVideo;
@property(nonatomic, copy) BOOL(^videoInputReadyCallback)(void);
@property(nonatomic, copy) BOOL(^audioInputReadyCallback)(void);
@property(nonatomic, copy) void(^audioProcessingCallback)(SInt16 **samplesRef, CMItemCount numSamplesInBuffer);
@property(nonatomic) BOOL enabled;
@property(nonatomic, readonly) AVAssetWriter *assetWriter;
@property(nonatomic, readonly) CMTime duration;
@property(nonatomic, assign) CGAffineTransform transform;
@property(nonatomic, copy) NSArray *metaData;
@property(nonatomic, assign, getter = isPaused) BOOL paused;
@property(nonatomic, retain) UCloudGPUImageContext *movieWriterContext;

// Initialization and teardown
- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize;
- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize fileType:(NSString *)newFileType outputSettings:(NSDictionary *)outputSettings;

- (void)setHasAudioTrack:(BOOL)hasAudioTrack audioSettings:(NSDictionary *)audioOutputSettings;

// Movie recording
- (void)startRecording;
- (void)startRecordingInOrientation:(CGAffineTransform)orientationTransform;
- (void)finishRecording;
- (void)finishRecordingWithCompletionHandler:(void (^)(void))handler;
- (void)cancelRecording;
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;
- (void)enableSynchronizationCallbacks;

@end
