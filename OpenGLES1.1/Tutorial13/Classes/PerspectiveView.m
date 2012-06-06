//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "PerspectiveView.h"

#define DEGREES_TO_RADIANS(angle) ( angle * 3.141592 / 180.0 )

//: 로컬객체를 정의할 때는 왼손좌표계를 기준으로 정의한다
//: 카메라의 디폴트 위치는 (0,0,0)이고 바라보는 방향은 -z 방향이다.
GLfloat verticesForGL_TRIANGLE_STRIP[3][3*3] = 
{
    //: 삼각형1
    {
        -0.5,  0.5, -1.5,          //v1
        -0.8,  0.0, -1.5,          //v2        
        -0.2,  0.0, -1.5,           //v3   
    },
    //:삼각형2
    {
         0.5,  0.5, -3.0,            //v1   
         0.2,  0.0, -3.0,            //v2           
         0.8,  0.0, -3.0,            //v3   
    },
};

void gluPerspectivef(GLfloat fovy, GLfloat aspect, GLfloat near, GLfloat far)
{
    GLfloat h = 2 * near * tanf(DEGREES_TO_RADIANS(fovy/2));
    GLfloat top = h;
    GLfloat bottom = -h;
    GLfloat left = aspect * bottom;
    GLfloat right = aspect * top;
    glFrustumf(left, right, bottom, top, near, far);
}

@implementation PerspectiveView


-(void)setupView
{
    //: 깊이 테스트 실시
    glEnable(GL_DEPTH_TEST);
    //: 작거나 같으면 깊이 테스트 통과
    glDepthFunc(GL_LEQUAL);

    //: 행렬 모드는 투영 행렬로 변경한다
	glMatrixMode(GL_PROJECTION);
    
    //: 투영행렬을 초기화 한다
	glLoadIdentity();
    
    //: 원교투영으로 설정한다.
    //: near, far값은 카메라 렌즈와의 거리이지 위치가 아니다.
    //: 음의 near 또는 far 값은 디폴트 카메라 렌즈의 방향에서 벗어나게 되어 
    //: 화면에 아무것도 그려지지 않는다.
    //: 따라서 near, far 모두 양수로 설정해야 한다.
	//glFrustumf(-1.0f, 1.0f, -1.5f, 1.5f, 1.0f, 20.0f); 
    
    //: glFrustum 함수 호출 대신에 시야각과 종횡비를 설정하여 
    //: 원근투영행렬을 만든다
    gluPerspectivef(60, 320.0/480.0, 1.0, 20.0);
	
    //: 뷰포트의 크기를 전체 화면으로 설정한다.
	glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
}


-(void)renderView
{
    //: 배경을 검은색으로 지운다
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    //: 깊이 버퍼를 1.0으로 초기화 한다.
    glClearDepthf(1.0f);
    
    //: 렌더링을 할 때마다 컬러버퍼와 깊이버퍼를 지운다
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //: 행렬 모드는 모델뷰 행렬로 변경한다
    glMatrixMode(GL_MODELVIEW);
    //: 모델뷰 행렬을 초기화한다
    glLoadIdentity();
    for(int i=0; i<2; i++)
    {
        //: 정점배열을 설정한다
        glVertexPointer(3, GL_FLOAT, sizeof(GLfloat)*3,
                        verticesForGL_TRIANGLE_STRIP[i]);
        
        //: 색상 칠하기 방법을 설정한다
        glShadeModel(GL_SMOOTH);
        
        //: 정점 배열 사용을 ON
        glEnableClientState(GL_VERTEX_ARRAY);
        {
            //: 처리할 정점의 개수는 4개
            glDrawArrays(GL_LINE_LOOP, 0, 3);
        }
        glDisableClientState(GL_VERTEX_ARRAY);
    }
}

-(void)dealloc
{
    [super dealloc];
}
@end
