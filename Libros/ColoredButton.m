//
//  ColoredButton.m
//  Libros
//
//  Created by Sean Hess on 1/30/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ColoredButton.h"

#define EDGE_INSETS UIEdgeInsetsMake(18, 18, 18, 18)

@implementation ColoredButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStyle:(ColoredButtonStyle)style {
    UIImage * normal = [self imageForStyle:style];
    UIImage * highlight = [self highlightImageForStyle:style];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:highlight forState:UIControlStateHighlighted];
    
    UIColor * color = [self fontColorForStyle:style];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (UIImage*)imageForStyle:(ColoredButtonStyle)style {
    NSString * name = [NSString stringWithFormat:@"%@Button.png", [self nameForStyle:style]];
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:EDGE_INSETS];
}

- (UIImage*)highlightImageForStyle:(ColoredButtonStyle)style {
    NSString * name = [NSString stringWithFormat:@"%@ButtonHighlight.png", [self nameForStyle:style]];
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:EDGE_INSETS];
}

- (NSString*)nameForStyle:(ColoredButtonStyle)style {
    if (style == ColoredButtonStyleBlack) return @"black";
    if (style == ColoredButtonStyleBlue) return @"blue";
    if (style == ColoredButtonStyleGray) return @"grey";
    if (style == ColoredButtonStyleGreen) return @"green";
    if (style == ColoredButtonStyleOrange) return @"orange";
    if (style == ColoredButtonStyleTan) return @"tan";
    if (style == ColoredButtonStyleWhite) return @"white";
    else return @"gray";
}

-(UIColor*)fontColorForStyle:(ColoredButtonStyle)style {
    UIColor * light = [UIColor whiteColor];
    UIColor * dark = [UIColor darkGrayColor];
    
    if (style == ColoredButtonStyleBlack) return light;
    if (style == ColoredButtonStyleBlue) return light;
    if (style == ColoredButtonStyleGray) return dark;
    if (style == ColoredButtonStyleGreen) return light;
    if (style == ColoredButtonStyleOrange) return light;
    if (style == ColoredButtonStyleTan) return dark;
    if (style == ColoredButtonStyleWhite) return dark;
    else return dark;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
