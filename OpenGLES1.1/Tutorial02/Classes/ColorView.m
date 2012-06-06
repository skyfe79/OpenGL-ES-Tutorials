//
//  DrawPointView.m
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 1..
//  Copyright 2011 individual. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView
-(void)setupView
{	
	self.multipleTouchEnabled = YES;
	r = g = b = 0.0;
	a = 1.0f;
}

-(void)renderView
{
	glClearColor(r, g, b, a);
	glClear(GL_COLOR_BUFFER_BIT);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	r = (GLfloat)((arc4random() % 255) / 255.0f);
	g = (GLfloat)((arc4random() % 255) / 255.0f);
	b = (GLfloat)((arc4random() % 255) / 255.0f);
	a = (GLfloat)((arc4random() % 255) / 255.0f);
}
@end
