//
//  OGLView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 9. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "OGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

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
        framebuffer = 0;
        colorRenderBuffer = 0;
        depthRenderBuffer = 0;
        
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
    if(context!=nil)
    {
        [context release];
        context = nil;
    }
    
    if(framebuffer)
    {
        glDeleteBuffers(1, &framebuffer);
        framebuffer = 0;
    }
    
    if(colorRenderBuffer)
    {
        glDeleteBuffers(1, &colorRenderBuffer);
        colorRenderBuffer=0;
    }
    
    if(depthRenderBuffer)
    {
        glDeleteBuffers(1, &depthRenderBuffer);
        depthRenderBuffer=0;
    }
    
    
    [super dealloc];
}

-(void)setupLayer
{
	eaglLayer = (CAEAGLLayer *)self.layer;
	[eaglLayer setOpaque:YES];
	//: 추가해야 함
	[eaglLayer setDrawableProperties:[NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
									  kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
									  nil]];
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
    //: 색상렌더 버퍼 생성
	glGenRenderbuffersOES(1, &colorRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer);    

    //: 깊이렌더 버퍼 생성
    glGenRenderbuffersOES(1, &depthRenderBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderBuffer);
}

-(void)setupFrameBuffer
{
	glGenFramebuffersOES(1, &framebuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderBuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderBuffer);
}

-(void)setupDisplayLink
{
	CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)setupView
{
}

- (void)layoutSubviews
{
    //: layoutSubview는 뷰의 프레임이 변경될 때 호출되므로 여기서 렌더버퍼의 스토리지 크기를 설정하는 것이 좋다
    GLint backingWidth;
    GLint backingHeight;
    
    //: 현재 레이어의 크기를 바탕으로 렌더 버퍼의 크기를 잡는다
    //: 색상 버퍼
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_RGBA8_OES, backingWidth, backingHeight);
    
    //: 깊이 버퍼
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderBuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderBuffer);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"프레임버퍼 생성 실패 %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return ;
    }
}

-(void)renderView
{
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

-(void)render:(CADisplayLink *)displayLink
{
    [EAGLContext setCurrentContext:context];
	[self renderView];
    
    //: 렌더버퍼가 색상 버퍼로만 구성되면 아랫줄을 할 필요가 없지만
    //: 여러 버퍼(깊이나 스텐실)를 포함하게 되면 아랫줄을 꼭 해줘야 한다
    //: 그것은 presentRenderbuffer 메서드로 화면에 보일 렌더버퍼의 스토리지는
    //: 반드시 renderbufferStorage:fromDrawable: 로 할당한 것만 되기 때문이다.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderBuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
@end
