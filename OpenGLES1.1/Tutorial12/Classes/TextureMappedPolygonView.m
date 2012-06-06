//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import "TextureMappedPolygonView.h"

GLfloat verticesForGL_TRIANGLE_STRIP[2][7*3] = {
    {
        0.2, 1.05, 0.1,          //v1
        1.0, 0.0, 0.0, 1.0,      //RED
        
        0.2, 0.45, 0.1,          //v2
        1.0, 0.0, 0.0, 1.0,      //RED
        
        0.8, 1.05, 0.1,          //v3   
        1.0, 0.0, 0.0, 1.0       //RED
    },
    
    {
        0.4, 0.8, 0.9,          //v1
        0.0, 0.0, 1.0, 1.0,      //BLUE
        
        0.4, 0.4, 0.9,          //v2
        0.0, 0.0, 1.0, 1.0,      //BLUE
        
        0.8, 0.8, 0.9,          //v3   
        0.0, 0.0, 1.0, 1.0       //BLUE
    },
};

@implementation TextureMappedPolygonView

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
    
    //: 직교투영으로 설정한다.
    //: 종횡비를 맞춘다
	glOrthof(0.0f, 1.0f, 0.0f, 1.5f, 1.0, -1.0f);
	
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
        glVertexPointer(3, GL_FLOAT, sizeof(GLfloat)*7,
                        verticesForGL_TRIANGLE_STRIP[i]);
        //: 색상배역을 설정한다
        glColorPointer(4, GL_FLOAT, sizeof(GLfloat)*7,
                       verticesForGL_TRIANGLE_STRIP[i]+3);
        
        //: 색상 칠하기 방법을 설정한다
        glShadeModel(GL_SMOOTH);
        
        //: 정점 배열 사용을 ON
        glEnableClientState(GL_VERTEX_ARRAY);
        //: 색상 배열 사용을 ON
        glEnableClientState(GL_COLOR_ARRAY);
        {
            //: 처리할 정점의 개수는 4개
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
        }
        //: 색상 배열 사용을 OFF
        glDisableClientState(GL_COLOR_ARRAY);
    }
}

-(void)dealloc
{
    [super dealloc];
}
@end
