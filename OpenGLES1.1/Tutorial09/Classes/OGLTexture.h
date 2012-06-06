//
//  OGLTexture.h
//  Tutorial01
//
//  Created by KIM SUNG CHEOL on 12. 2. 20..
//  Copyright (c) 2012 individual. All rights reserved.
//

/**
 * @brief   텍스춰를 표현하는 객체
 * @author  김성철
 */
#import <Foundation/Foundation.h>

@interface OGLTexture : NSObject
{
    //: 텍스춰 아이디
    GLuint  textureID;
    //: 이미지 데이터 
    GLubyte *imageData;
    //: 이미지 너비, 높이
    size_t  width;
    size_t  height;
}
@property(nonatomic, readonly) GLuint   textureID;
@property(nonatomic, readonly) GLubyte  *imageData;
@property(nonatomic, readonly) size_t   width;
@property(nonatomic, readonly) size_t   height;
+(id)textureWithImagePath:(NSString *)path;
-(id)initWithImagePath:(NSString *)path;
-(BOOL)bindTexture;
@end
