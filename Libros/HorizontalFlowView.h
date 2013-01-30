//
//  HorizontalFlowView.h
//  Libros
//
//  Created by Sean Hess on 1/30/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.

//  Give it N subviews. Will lay them out, vertically centered, and calculate its own size based on them
//  it will not count hidden subviews
//  will lay them out in order, left to right

#import <UIKit/UIKit.h>

@interface HorizontalFlowView : UIView

@property (nonatomic) CGFloat padding;
- (void)flow;

@end
