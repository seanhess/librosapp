//
//  Texture.m
//  Libros
//
//  Created by Sean Hess on 3/13/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "Appearance.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Appearance

+(UIColor*)background {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-texture-bg.png"]];
}

+(UIColor*)lightGray {
    return UIColorFromRGB(0xE5E5E5);
}

+(UIColor*)darkTabBarColor {
    return UIColorFromRGB(0x838383);
}

+(UIColor*)lightTabBarColor {
    return UIColorFromRGB(0xCECECE);
}

+(UIColor*)highlightBlue {
    return UIColorFromRGB(0x10A5DD);
}

+(UIView*)tableSelectedBackgroundView {
    UIView * colorView = [UIView new];
    colorView.backgroundColor = self.highlightBlue;
    return colorView;
}

@end
