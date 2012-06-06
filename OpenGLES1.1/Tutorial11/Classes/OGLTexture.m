//
//  OGLTexture.m
//  Tutorial01
//
//  Created by KIM SUNG CHEOL on 12. 2. 20..
//  Copyright (c) 2012 individual. All rights reserved.
//

#import "OGLTexture.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface OGLTexture()
-(BOOL)loadUIImage:(NSString *)path;
-(BOOL)generateTexture;
-(void)deleteTextre;
@end

@implementation OGLTexture
@synthesize textureID;
@synthesize imageData;
@synthesize width;
@synthesize height;

+(id)textureWithImagePath:(NSString *)path
{
    return [[[self alloc] initWithImagePath:path] autorelease];
}

-(id)initWithImagePath:(NSString *)path
{
    self = [super init];
    if(self!=nil)
    {
        textureID = -1;
        imageData = NULL;
        width     = -1;
        height    = -1;
        if([self loadUIImage:path])
        {
            [self generateTexture];
        }
    }
    return self;
}

-(void)dealloc
{
    [self deleteTextre];
    if(imageData)
    {
        free(imageData);
    }
    [super dealloc];
}

-(BOOL)loadUIImage:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if(image == nil)
        return NO;
    
    //: 이미지의 정보를 얻어 온다
    CGImageRef cgImage = [image CGImage];
    width = CGImageGetWidth(cgImage);
    height= CGImageGetHeight(cgImage);
    
    //: 이미지의 너비와 높이가 2의 승수인지 살펴봐야 하지만
    //: 생략한다
    
    //: 이미지 데이터의 바이트 배열을 만들기 위해서
    //: 비트맵 컨텍스트를 만들고 거기에 이미지를 그린다
    //: 텍스춰로 사용하는 이미지는 모두 RGBA 4바이트로 가정한다
    if(imageData)
        free(imageData);
    
    imageData = (GLubyte *)calloc(width*height*4, sizeof(GLubyte));
    if(imageData == NULL)
        return NO;
    
    //: 이미지를 그릴 비트맵컨텍스트를 생성한다
    CGContextRef bitmapContext = CGBitmapContextCreate(imageData,
                                                       width,
                                                       height,
                                                       8,
                                                       width*4,
                                                       CGImageGetColorSpace(cgImage),
                                                       kCGImageAlphaPremultipliedLast);
    
    //: PVRTC 압축 이미지가 아니면 텍스춰이미지가 역상으로 나온다
    //: 그것을 바로 잡아 준다
    CGContextTranslateCTM (bitmapContext, 0, height);
    CGContextScaleCTM (bitmapContext, 1.0, -1.0);
    
    //: 이미지를 비트맵컨텍스트에 그린다
    CGContextDrawImage(bitmapContext, 
                       CGRectMake(0, 0, width, height), 
                       cgImage);
    
    //: 비트맵데이터만 필요하므로 컨텍스트는 메모리 해제한다
    CGContextRelease(bitmapContext);
    return YES;
}

/**
 * @brief 텍스춰를 생성한다
 */
-(BOOL)generateTexture
{
    if(imageData == NULL)
        return NO;
    
    if(textureID != -1)
    {
        glDeleteTextures(1, &textureID);
        textureID = -1;
    }
    
    //: 텍스춰 구분자를 생성한다
    glGenTextures(1, &textureID);
    
    //: 텍스춰를 바인딩한다
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    //: 텍스춰 파라미터를 설정한다
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    //: 텍스춰 구분자와 이미지 데이터를 연결한다
    glTexImage2D(GL_TEXTURE_2D,
                 0, 
                 GL_RGBA,
                 width,
                 height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 imageData);
    return YES;
}
/**
 * @brief 텍스춰를 삭제한다
 */
-(void)deleteTextre
{
    if(textureID != -1)
    {
        glDeleteTextures(1, &textureID);
        textureID = -1;
    }
}

/**
 * @brief 텍스춰를 바인딩한다
 */
-(BOOL)bindTexture
{
    if(textureID == -1)
        return NO;
    
    //: 텍스춰를 바인딩한다
    glBindTexture(GL_TEXTURE_2D, textureID);
    return YES;
}
@end
