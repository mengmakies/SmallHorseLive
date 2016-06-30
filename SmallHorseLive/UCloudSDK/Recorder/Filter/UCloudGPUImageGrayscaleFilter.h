#import "UCloudGPUImageFilter.h"

extern NSString *const kUCloudGPUImageLuminanceFragmentShaderString;

/** Converts an image to grayscale (a slightly faster implementation of the saturation filter, without the ability to vary the color contribution)
 */
@interface UCloudGPUImageGrayscaleFilter : UCloudGPUImageFilter

@end
