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
    }
    return self;
}

-(NSInteger)makeFrame:(id)framesetter_ location:(NSInteger)location {
    // create this once!
    
    CTFramesetterRef framesetter = (__bridge CTFramesetterRef)framesetter_;
    
    // Draw the first page!
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect insetFrame = CGRectInset(self.bounds, self.frameXOffset, self.frameYOffset);
    CGPathAddRect(path, NULL, insetFrame);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(location, 0), path, NULL);
    self.ctFrame = (__bridge id)frame;
    self.hidden = NO;
    [self setNeedsDisplay];
    
    CFRelease(frame);
    CFRelease(path);
    
    return CTFrameGetVisibleStringRange(frame).length;
}

-(void)renderFrame:(id)frame {
    self.ctFrame = frame;
    self.hidden = NO;
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
