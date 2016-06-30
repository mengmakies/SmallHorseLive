//
//  GPUImageHistogramEqualizationFilter.h
//  FilterShowcase
//
//  Created by Adam Marcus on 19/08/2014.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//

#import "UCloudGPUImageFilterGroup.h"
#import "UCloudGPUImageHistogramFilter.h"
#import "UCloudGPUImageRawDataOutput.h"
#import "UCloudGPUImageRawDataInput.h"
#import "UCloudGPUImageTwoInputFilter.h"

@interface UCloudGPUImageHistogramEqualizationFilter : UCloudGPUImageFilterGroup
{
    UCloudGPUImageHistogramFilter *histogramFilter;
    UCloudGPUImageRawDataOutput *rawDataOutputFilter;
    UCloudGPUImageRawDataInput *rawDataInputFilter;
}

@property(readwrite, nonatomic) NSUInteger downsamplingFactor;

- (id)initWithHistogramType:(UCloudGPUImageHistogramType)newHistogramType;

@end
