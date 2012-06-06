//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "DrawPolygonView.h"

GLfloat pointsForGL_LINES[] = {
    0.2, 0.2, 0.0,  //v1
    0.8, 0.2, 0.0,  //v2
    0.2, 0.8, 0.0,  //v3
    0.8, 0.8, 0.0,  //v4
};

GLfloat pointsForGL_LINE_LOOP[] = {
    0.2, 0.2, 0.0,  //v1
    0.8, 0.2, 0.0,  //v2
    0.8, 0.8, 0.0,  //v3
    0.2, 0.8, 0.0,  //v4
};

GLfloat pointsForGL_LINE_STRIP[] = {
    0.2, 0.2, 0.0,  //v1
	0.8, 0.2, 0.0,  //v2
	0.2, 0.8, 0.0,  //v3
	0.8, 0.8, 0.0,  //v4
};

GLfloat pointsForGL_TRIANGLES[] = {
    0.2, 0.2, 0.0,  //v1
    0.8, 0.2, 0.0,  //v2
    0.8, 0.8, 0.0,  //v3
    
    0.2, 0.3, 0.0,  //v4
    0.8, 0.9, 0.0,  //v5
    0.2, 0.9, 0.0,  //v6
};

GLfloat pointsForGL_TRIANGLE_STRIP[] = {
    0.2, 0.8, 0.0,  //v1
    0.2, 0.2, 0.0,  //v2
    0.8, 0.8, 0.0,  //v3
    0.8, 0.2, 0.0,  //v4
};

GLfloat pointsForGL_TRIANGLE_FAN[] = {
    0.2, 0.8, 0.0,  //v1
    0.2, 0.2, 0.0,  //v2
    0.8, 0.2, 0.0,  //v3
    0.8, 0.8, 0.0,  //v4
    0.8, 1.0, 0.0,  //v5
};

@implementation DrawPolygonView

-(void)setupView
{
    //: 행렬 모드는 투영 행렬로 변경한다
	glMatrixMode(GL_PROJECTION);
    
    //: 투영행렬을 초기화 한다
	glLoadIdentity();
    
    //: 직교투영으로 설정한다
	glOrthof(0.0f, 1.0f, 0.0f, 1.0f, -1.0f, 1.0f);
	
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
	glVertexPointer(3, GL_FLOAT, 0, pointsForGL_TRIANGLE_FAN);
	glEnableClientState(GL_VERTEX_ARRAY);
	{
        //: 점의 크기를 설정한다
		glPointSize(10);
        //: 점의 색상을 설정한다
		glColor4f(1.0, 1.0, 1.0, 1.0);
        //: 정점 배열의 내용을 점으로 그린다
        //: 삼각형 3개를 그린다. 처리할 정점의 개수는 5개
		glDrawArrays(GL_TRIANGLE_FAN, 0, 5);
	}
	glDisableClientState(GL_VERTEX_ARRAY);
}
@end
