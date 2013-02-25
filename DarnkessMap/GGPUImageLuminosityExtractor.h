//
//  GGPULuminiscensceExtractor.h
//  DarnkessMap
//
//  Created by Emiliano Burgos on 2/24/13.
//  Copyright (c) 2013 Emiliano Burgos. All rights reserved.
//
#import "GPUImageAverageColor.h"

@interface GGPUImageLuminosityExtractor : GPUImageFilter
{
    GLint redUniform;
    GLint greenUniform;
    GLint blueUniform;
//    NSUInteger numberOfStages;
//    NSMutableArray *stageTextures, *stageFramebuffers, *stageSizes;
//    
    GLubyte *rawImagePixels;
//    GLProgram *secondFilterProgram;
//    GLint secondFilterPositionAttribute, secondFilterTextureCoordinateAttribute;
//    GLint secondFilterInputTextureUniform, secondFilterInputTextureUniform2;
//    GLint secondFilterTexelWidthUniform, secondFilterTexelHeightUniform;
}

// This block is called on the completion of color averaging for a frame
@property(nonatomic, copy) void(^luminosityCallbackBlock)(CGFloat time, CMTime frameTime);

@property (readwrite, nonatomic) CGFloat red;
@property (readwrite, nonatomic) CGFloat green;
@property (readwrite, nonatomic) CGFloat blue;

- (void)extractLuminosityAtFrameTime:(CMTime)frameTime;
//- (void)initializeSecondaryAttributes;

@end
