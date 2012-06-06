//
//  DrawPointView.h
//  Tutorial01
//
//  Created by SUNG CHEOL KIM on 11. 10. 2..
//  Copyright 2011 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGLView.h"
#import "OGLTexture.h"
@interface TextureMappedPolygonView : OGLView
{
    OGLTexture *texture;
}
@end
