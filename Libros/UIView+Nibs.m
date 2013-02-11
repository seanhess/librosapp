//
//  UIView+Nibs.m
//  Libros
//
//  Created by Sean Hess on 2/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UIView+Nibs.h"

@implementation UIView (Nibs)

+(id)loadFromNibNamed:(NSString *)nibName {
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
}

@end
