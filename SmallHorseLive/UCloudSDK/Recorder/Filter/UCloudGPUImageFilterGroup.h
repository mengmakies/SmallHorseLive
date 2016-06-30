#import "UCloudGPUImageOutput.h"
#import "UCloudGPUImageFilter.h"

@interface UCloudGPUImageFilterGroup : UCloudGPUImageOutput <UCloudGPUImageInput>
{
    NSMutableArray *filters;
    BOOL isEndProcessing;
}

@property(readwrite, nonatomic, strong) UCloudGPUImageOutput<UCloudGPUImageInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) UCloudGPUImageOutput<UCloudGPUImageInput> *inputFilterToIgnoreForUpdates;

// Filter management
- (void)addFilter:(UCloudGPUImageOutput<UCloudGPUImageInput> *)newFilter;
- (UCloudGPUImageOutput<UCloudGPUImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end
