//
//  OGLView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 9. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "OGLView.h"

@interface OGLView()
-(void)setupLayer;
-(void)setupContext;
-(void)setupRenderBuffer;
-(void)setupFrameBuffer;
-(void)setupDisplayLink;
-(void)render:(CADisplayLink *)displayLink;
@end


@implementation OGLView
+(Class)layerClass 
{
	return [CAEAGLLayer class];
}
+(id)oglView
{
	return [[[self alloc] initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setupLayer];
		[self setupContext];
		[self setupRenderBuffer];
		[self setupFrameBuffer];
		
		[self setupView];
		
		[self setupDisplayLink];
		
    }
    return self;
}

- (void)dealloc 
{
	[context release];
	context = nil;
    [super dealloc];
}

-(void)setupLayer
{
	eaglLayer = (CAEAGLLayer *)self.layer;
	[eaglLayer setOpaque:YES];
}

-(void)setupContext
{
	EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES1;
	context = [[EAGLContext alloc] initWithAPI:api];
	if(context == nil)
	{
		NSLog(@"OpenGLES 1.0 Context 초기화 실패");
		exit(1);
	}
	
	if(![EAGLContext setCurrentContext:context])
	{
		NSLog(@"현재 OpenGL context 설정 실패");
		exit(1);
	}
}

-(void)setupRenderBuffer
{
	glGenRenderbuffersOES(1, &colorRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer];
}

-(void)setupFrameBuffer
{
	GLuint framebuffer;
	glGenFramebuffersOES(1, &framebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderBuffer);
}

-(void)setupDisplayLink
{
	CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)setupView
{
}

-(void)renderView
{
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
}

-(void)render:(CADisplayLink *)displayLink
{
	[self renderView];
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
@end
