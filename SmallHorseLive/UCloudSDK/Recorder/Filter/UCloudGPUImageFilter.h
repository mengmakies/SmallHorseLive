#import "UCloudGPUImageOutput.h"

#define UCloudSTRINGIZE(x) #x
#define UCloudSTRINGIZE2(x) UCloudSTRINGIZE(x)
#define UCloudSHADER_STRING(text) @ UCloudSTRINGIZE2(text)

#define UCloudGPUImageHashIdentifier #
#define UCloudGPUImageWrappedLabel(x) x
#define UCloudGPUImageEscapedHashIdentifier(a) UCloudGPUImageWrappedLabel(UCloudGPUImageHashIdentifier)a

extern NSString *const kUCloudGPUImageVertexShaderString;
extern NSString *const kUCloudGPUImagePassthroughFragmentShaderString;

struct UCloudGPUVector4 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
    GLfloat four;
};
typedef struct UCloudGPUVector4 UCloudGPUVector4;

struct UCloudGPUVector3 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
};
typedef struct UCloudGPUVector3 UCloudGPUVector3;

struct UCloudGPUMatrix4x4 {
    UCloudGPUVector4 one;
    UCloudGPUVector4 two;
    UCloudGPUVector4 three;
    UCloudGPUVector4 four;
};
typedef struct UCloudGPUMatrix4x4 UCloudGPUMatrix4x4;

struct UCloudGPUMatrix3x3 {
    UCloudGPUVector3 one;
    UCloudGPUVector3 two;
    UCloudGPUVector3 three;
};
typedef struct UCloudGPUMatrix3x3 UCloudGPUMatrix3x3;

/** GPUImage's base filter class
 
 Filters and other subsequent elements in the chain conform to the GPUImageInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */
@interface UCloudGPUImageFilter : UCloudGPUImageOutput <UCloudGPUImageInput>
{
    UCloudGPUImageFramebuffer *firstInputFramebuffer;
    
    UCloudGLProgram *filterProgram;
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform;
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    
    BOOL isEndProcessing;

    CGSize currentFilterSize;
    UCloudGPUImageRotationMode inputRotation;
    
    BOOL currentlyReceivingMonochromeInput;
    
    NSMutableDictionary *uniformStateRestorationBlocks;
    dispatch_semaphore_t imageCaptureSemaphore;
}

@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;

/// @name Initialization and teardown

/**
 Initialize with vertex and fragment shaders
 
 You make take advantage of the UCloudSHADER_STRING macro to write your shaders in-line.
 @param vertexShaderString Source code of the vertex shader to use
 @param fragmentShaderString Source code of the fragment shader to use
 */
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;

/**
 Initialize with a fragment shader
 
 You may take advantage of the UCloudSHADER_STRING macro to write your shader in-line.
 @param fragmentShaderString Source code of fragment shader to use
 */
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
/**
 Initialize with a fragment shader
 @param fragmentShaderFilename Filename of fragment shader to load
 */
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)initializeAttributes;
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(UCloudGPUImageRotationMode)rotation;

/// @name Managing the display FBOs
/** Size of the frame buffer object
 */
- (CGSize)sizeOfFBO;

/// @name Rendering
+ (const GLfloat *)textureCoordinatesForRotation:(UCloudGPUImageRotationMode)rotationMode;
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;
- (CGSize)outputFrameSize;

/// @name Input parameters
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setInteger:(GLint)newInteger forUniformName:(NSString *)uniformName;
- (void)setFloat:(GLfloat)newFloat forUniformName:(NSString *)uniformName;
- (void)setSize:(CGSize)newSize forUniformName:(NSString *)uniformName;
- (void)setPoint:(CGPoint)newPoint forUniformName:(NSString *)uniformName;
- (void)setFloatVec3:(UCloudGPUVector3)newVec3 forUniformName:(NSString *)uniformName;
- (void)setFloatVec4:(UCloudGPUVector4)newVec4 forUniform:(NSString *)uniformName;
- (void)setFloatArray:(GLfloat *)array length:(GLsizei)count forUniform:(NSString*)uniformName;

- (void)setMatrix3f:(UCloudGPUMatrix3x3)matrix forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setMatrix4f:(UCloudGPUMatrix4x4)matrix forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setFloat:(GLfloat)floatValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setPoint:(CGPoint)pointValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setSize:(CGSize)sizeValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setVec3:(UCloudGPUVector3)vectorValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setVec4:(UCloudGPUVector4)vectorValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setFloatArray:(GLfloat *)arrayValue length:(GLsizei)arrayLength forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;
- (void)setInteger:(GLint)intValue forUniform:(GLint)uniform program:(UCloudGLProgram *)shaderProgram;

- (void)setAndExecuteUniformStateCallbackAtIndex:(GLint)uniform forProgram:(UCloudGLProgram *)shaderProgram toBlock:(dispatch_block_t)uniformStateBlock;
- (void)setUniformsForProgramAtIndex:(NSUInteger)programIndex;

@end
