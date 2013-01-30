//
//  ColoredButton.h
//  Libros
//
//  Created by Sean Hess on 1/30/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ColoredButtonStyleGreen,
    ColoredButtonStyleOrange,
    ColoredButtonStyleBlack,
    ColoredButtonStyleBlue,
    ColoredButtonStyleGray,
    ColoredButtonStyleWhite,
} ColoredButtonStyle;

@interface ColoredButton : UIButton

@property (nonatomic) ColoredButtonStyle style;

@end
