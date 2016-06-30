#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageBuffer : UCloudGPUImageFilter
{
    NSMutableArray *bufferedFramebuffers;
}

@property(readwrite, nonatomic) NSUInteger bufferSize;

@end
