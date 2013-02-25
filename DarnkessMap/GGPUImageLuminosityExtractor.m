#import "GGPUImageLuminosityExtractor.h"
#import "GPUImage.h"



NSString *const akGPUImageRGBFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform highp float red;
 uniform highp float green;
 uniform highp float blue;
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(textureColor.r * red, textureColor.g * green, textureColor.b * blue, 1.0);
 }
);


//@implementation GPUImageLuminosity
@implementation GGPUImageLuminosityExtractor

@synthesize red = _red, blue = _blue, green = _green;
@synthesize luminosityCallbackBlock = _luminosityCallbackBlock;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:akGPUImageRGBFragmentShaderString]))
    {
		return nil;
    }

    
    __unsafe_unretained GGPUImageLuminosityExtractor *weakSelf = self;
    [self setFrameProcessingCompletionBlock:^(GPUImageOutput *filter, CMTime frameTime) {
        [weakSelf extractLuminosityAtFrameTime:frameTime];
    }];
    
    
    redUniform = [filterProgram uniformIndex:@"red"];
    self.red = 1.0;
    
    greenUniform = [filterProgram uniformIndex:@"green"];
    self.green = 1.0;
    
    blueUniform = [filterProgram uniformIndex:@"blue"];
    self.blue = 1.0;
    
    return self;
}


#pragma mark -
#pragma mark Callbacks

- (void)extractLuminosityAtFrameTime:(CMTime)frameTime;
{
//    CGSize finalStageSize = [[stageSizes lastObject] CGSizeValue];
    NSUInteger totalNumberOfPixels = round(600*400);
    
    if (rawImagePixels == NULL)
    {
        rawImagePixels = (GLubyte *)malloc(totalNumberOfPixels * 4);
    }
    
    glReadPixels(0, 0, 600, 400, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
    
    NSUInteger luminanceTotal = 0;
    NSUInteger byteIndex = 0;
    for (NSUInteger currentPixel = 0; currentPixel < totalNumberOfPixels; currentPixel++)
    {
        luminanceTotal += rawImagePixels[byteIndex];
        byteIndex += 4;
    }
    
    CGFloat normalizedLuminosityTotal = ((CGFloat)luminanceTotal / (CGFloat)totalNumberOfPixels / 255.0) * 255.0;
    
    if (_luminosityCallbackBlock != NULL)
    {
        _luminosityCallbackBlock(normalizedLuminosityTotal, frameTime);
    }
}

- (void)setRed:(CGFloat)newValue;
{
    _red = newValue;
    
    [self setFloat:_red forUniform:redUniform program:filterProgram];
}

- (void)setGreen:(CGFloat)newValue;
{
    _green = newValue;
    
    [self setFloat:_green forUniform:greenUniform program:filterProgram];
}

- (void)setBlue:(CGFloat)newValue;
{
    _blue = newValue;
    
    [self setFloat:_blue forUniform:blueUniform program:filterProgram];
}

@end
