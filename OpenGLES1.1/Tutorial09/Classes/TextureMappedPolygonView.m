//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "TextureMappedPolygonView.h"


GLfloat verticesForGL_TRIANGLE_STRIP[] = {
    0.2, 1.05, 0.0,          //v1
    1.0, 0.0, 0.0, 1.0,      //R
    0.0, 1.0,                //UV1
    
    0.2, 0.45, 0.0,          //v2
    0.0, 1.0, 0.0, 1.0,      //G
    0.0, 0.0,                //UV2
    
    0.8, 1.05, 0.0,          //v3
    0.0, 0.0, 1.0, 1.0,      //B
    1.0, 1.0,                //UV3
    
    0.8, 0.45, 0.0,          //v4
    1.0, 1.0, 0.0, 1.0,      //Y
    1.0, 0.0,                //UV4
};


@implementation TextureMappedPolygonView

-(void)setupView
{
    //: 행렬 모드는 투영 행렬로 변경한다
	glMatrixMode(GL_PROJECTION);
    
    //: 투영행렬을 초기화 한다
	glLoadIdentity();
    
    //: 직교투영으로 설정한다.
    //: 종횡비를 맞춘다
	glOrthof(0.0f, 1.0f, 0.0f, 1.5f, -1.0f, 1.0f);
	
    //: 뷰포트의 크기를 전체 화면으로 설정한다.
	glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    //: 텍스춰를 만든다
    NSString *texturePath = [[NSBundle mainBundle] pathForResource:@"gl" ofType:@"png"];
    texture = [OGLTexture textureWithImagePath:texturePath];
    [texture retain];
}

-(void)renderView
{
    //: 배경을 검은색으로 지운다
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
    //: 행렬 모드는 모델뷰 행렬로 변경한다
	glMatrixMode(GL_MODELVIEW);
    //: 모델뷰 행렬을 초기화한다
	glLoadIdentity();
	
    //: 정점배열을 설정한다
	glVertexPointer(3, GL_FLOAT, sizeof(GLfloat)*9, 
                    verticesForGL_TRIANGLE_STRIP);
    //: 색상배열을 설정한다
    glColorPointer(4, GL_FLOAT, sizeof(GLfloat)*9, 
                    &verticesForGL_TRIANGLE_STRIP[0]+3);
    //: 텍스춰배열을 설정한다ㅏ
    glTexCoordPointer(2, GL_FLOAT, sizeof(GLfloat)*9,
                      &verticesForGL_TRIANGLE_STRIP[0]+7);
    
    //: 색상 칠하기 방법을 설정한다
    glShadeModel(GL_SMOOTH);
    
    //: 텍스춰 배열 사용을 ON
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    //: 색상 배열 사용을 ON
    glEnableClientState(GL_COLOR_ARRAY);
    //: 정점 배열 사용을 ON
	glEnableClientState(GL_VERTEX_ARRAY);
	{
        //: 삼각형 3개를 그린다. 처리할 정점의 개수는 4개
        glEnable(GL_TEXTURE_2D);
        [texture bindTexture];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glDisable(GL_TEXTURE_2D);
	}
    //: 정점 배열 사용을 OFF
	glDisableClientState(GL_VERTEX_ARRAY);
    //: 색상 배열 사용을 OFF
    glDisableClientState(GL_COLOR_ARRAY);
    //: 텍스춰 좌표 배열 사용을 OFF
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void)dealloc
{
    if(texture!=nil)
    {
        [texture release];
        texture = nil;
    }
    [super dealloc];
}
@end
