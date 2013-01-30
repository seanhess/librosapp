//
//  HorizontalFlowView.m
//  Libros
//
//  Created by Sean Hess on 1/30/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "HorizontalFlowView.h"

@implementation HorizontalFlowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Don't do it in layoutSubViews then?

- (void)flow {
    
    __block CGFloat offsetX = 0;
    [self.subviews enumerateObjectsUsingBlock:^(UIView * view, NSUInteger index, BOOL * stop){
        if (view.hidden) return;
        CGRect frame = view.frame;
        frame.origin.x = offsetX;
        offsetX += frame.size.width + self.padding;
        view.frame = frame;
    }];
    
    CGRect frame = self.frame;
    frame.size.width = offsetX - self.padding;
    self.frame = frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
