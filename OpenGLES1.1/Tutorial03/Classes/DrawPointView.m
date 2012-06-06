//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "DrawPointView.h"


GLfloat points[] = {
	0.2, 0.2, 0.0,  //: 좌-하단
	0.8, 0.2, 0.0,  //: 우-하단
	0.2, 0.8, 0.0,  //: 좌-상단
	0.8, 0.8, 0.0,   //: 우-상단
    
    0.2, 0.2, -0.5,  //: 좌-하단
	0.8, 0.2, -0.5,  //: 우-하단
	0.2, 0.8, -0.5,  //: 좌-상단
	0.8, 0.8, -0.5   //: 우-상단
};

@implementation DrawPointView

-(void)setupFrameBuffer
{
    [super setupFrameBuffer];
    //: 3차원 표현이 가능하게
    //: 깊이 버퍼를 설정해야 한다
    //: 오버라이딩 형식이 좋을까?
    //: 아니면 플래그를 주어 설정하는 것이 나을까?
}

-(void)setupView
{
    //: 행렬 모드는 투영 행렬로 변경한다
	glMatrixMode(GL_PROJECTION);
    
    //: 투영행렬을 초기화 한다
	glLoadIdentity();
    
    //: 직교투영으로 설정한다
	//glOrthof(-1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f);
    glFrustumf(-1.0f, 1.0f, -1.0f, 1.0f, 1.0f, -1.0f);
	
    //: 뷰포트의 크기를 전체 화면으로 설정한다.
	glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
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
	glVertexPointer(3, GL_FLOAT, 0, points);
	glEnableClientState(GL_VERTEX_ARRAY);
	{
        //: 점의 크기를 설정한다
		glPointSize(10);
        //: 점의 색상을 설정한다
		glColor4f(1.0, 1.0, 1.0, 1.0);
        //: 정점 배열의 내용을 점으로 그린다
		glDrawArrays(GL_POINTS, 0, 8);
	}
	glDisableClientState(GL_VERTEX_ARRAY);
}
@end
