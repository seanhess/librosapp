//
//  ReaderPageView.m
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderPageView.h"
#import <CoreText/CoreText.h>

@interface ReaderPageView ()
@property (nonatomic) NSInteger position;
@property (nonatomic, strong) id ctFrame;
@end



@implementation ReaderPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.chapter = -1;
        self.page = -1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.chapter = -1;
        self.page = -1;
    }
    return self;
}

-(void)setFrame:(id)ctFrame chapter:(NSInteger)chapter page:(NSInteger)page {
//    if (self.chapter == chapter && self.page == page)
//        return;
//    
    self.chapter = chapter;
    self.page = page;
    self.ctFrame = ctFrame;
    self.hidden = NO;
    [self setNeedsDisplay];
}

-(void)clear {
    self.ctFrame = nil;
    self.chapter = -1;
    self.page = -1;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((__bridge CTFrameRef)self.ctFrame, context);
}
@end
