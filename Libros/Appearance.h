//
//  Texture.h
//  Libros
//
//  Created by Sean Hess on 3/13/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appearance : NSObject

+(UIColor*)background;
+(UIColor*)lightGray;
+(UIColor*)darkTabBarColor;
+(UIColor*)lightTabBarColor;
+(UIColor*)highlightBlue;
+(UIColor*)adjustedHighlightBlueForShadows;
+(UIColor*)boringGrayColor;
+(UIColor*)darkControlGrayColor;
+(UIView*)tableSelectedBackgroundView;

@end
