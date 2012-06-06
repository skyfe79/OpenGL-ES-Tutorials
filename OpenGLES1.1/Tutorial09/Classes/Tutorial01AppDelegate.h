//
//  Tutorial01AppDelegate.h
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 9. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGLView.h"
@interface Tutorial01AppDelegate : NSObject <UIApplicationDelegate> 
{
	OGLView	 *glView;
    UIWindow *window;
}
@property (nonatomic, retain) OGLView *glView;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

