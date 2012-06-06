//
//  OGLView.h
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 9. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface OGLView : UIView 
{
	CAEAGLLayer		*eaglLayer;
	EAGLContext		*context;
	GLuint			colorRenderBuffer;
}

@end
