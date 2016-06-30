#import <Foundation/Foundation.h>
#import "UCloudGPUImageOutput.h"

@interface UCloudGPUImageFilterPipeline : NSObject
{
    NSString *stringValue;
}

@property (strong) NSMutableArray *filters;

@property (strong) UCloudGPUImageOutput *input;
@property (strong) id <UCloudGPUImageInput> output;

- (id) initWithOrderedFilters:(NSArray*) filters input:(UCloudGPUImageOutput*)input output:(id <UCloudGPUImageInput>)output;
- (id) initWithConfiguration:(NSDictionary*) configuration input:(UCloudGPUImageOutput*)input output:(id <UCloudGPUImageInput>)output;
- (id) initWithConfigurationFile:(NSURL*) configuration input:(UCloudGPUImageOutput*)input output:(id <UCloudGPUImageInput>)output;

- (void) addFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)filter;
- (void) addFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)filter atIndex:(NSUInteger)insertIndex;
- (void) replaceFilterAtIndex:(NSUInteger)index withFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)filter;
- (void) replaceAllFilters:(NSArray *) newFilters;
- (void) removeFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)filter;
- (void) removeFilterAtIndex:(NSUInteger)index;
- (void) removeAllFilters;

- (UIImage *) currentFilteredFrame;
- (UIImage *) currentFilteredFrameWithOrientation:(UIImageOrientation)imageOrientation;
- (CGImageRef) newCGImageFromCurrentFilteredFrame;

@end
