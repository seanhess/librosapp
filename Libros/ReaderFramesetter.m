//
//  ReaderFrameCache.m
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

// TODO needs to store text positions for each page too
// locationForPage:(NSInteger)page
// pageNearestLocation:(NSInteger)location

#import "ReaderFramesetter.h"
#import "ReaderFormatter.h"
#import "ReaderPage.h"
#import <CoreText/CoreText.h>

#define FRAME_X_OFFSET 25
#define FRAME_Y_OFFSET 25

@interface ReaderFramesetter ()
@property (strong, nonatomic) NSMutableDictionary * chapters;
@property (nonatomic) CGSize size;
@end

@implementation ReaderFramesetter

-(id)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.size = size;
    }
    return self;
}

-(NSMutableDictionary*)chapters {
    if (!_chapters) {
        self.chapters = [NSMutableDictionary dictionary];
    }
    
    return _chapters;
}

-(id<NSCopying>)key:(NSInteger)chapter {
    return [NSNumber numberWithInteger:chapter];
}

-(BOOL)hasPagesForChapter:(NSInteger)chapter {
    if (self.chapters[[self key:chapter]]) return YES;
    return NO;
}

-(id)pageForChapter:(NSInteger)c page:(NSInteger)p {
    ReaderPage * page = self.chapters[[self key:c]][p];
    return page.frame;
}

-(NSInteger)pagesForChapter:(NSInteger)chapter {
    return [self.chapters[[self key:chapter]] count];
}

-(void)emptyExceptChapter:(NSInteger)chapter {
    NSMutableDictionary * newChapters = [NSMutableDictionary dictionary];
    newChapters[[self key:chapter]] = self.chapters[[self key:chapter]];
    self.chapters = newChapters;
}

-(void)empty {
    self.chapters = [NSMutableDictionary dictionary];
}

-(NSMutableArray*)generatePagesForChapter:(NSInteger)chapter {
    NSInteger location = 0;
    
    NSAttributedString * text = [self.delegate textForChapter:chapter];
    NSAssert(text, @"Delegate did not return text");
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    
    NSMutableArray * pages = [NSMutableArray array];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    
    while(location < text.length) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect insetFrame = CGRectInset(bounds, FRAME_X_OFFSET, FRAME_Y_OFFSET);
        CGPathAddRect(path, NULL, insetFrame);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(location, 0), path, NULL);
        NSInteger length = CTFrameGetVisibleStringRange(frame).length;
        ReaderPage * page = [ReaderPage new];
        page.frame = (__bridge id)frame;
        page.range = NSMakeRange(location, length);
        [pages addObject:page];
        
        location += length;
        CFRelease(frame);
        CFRelease(path);
    }
    
    CFRelease(framesetter);
    return pages;
}

// if the frames don't exist, generate them!
-(void)ensurePagesForChapter:(NSInteger)chapter {
    if (![self hasPagesForChapter:chapter])
        self.chapters[[self key:chapter]] = [self generatePagesForChapter:chapter];
}

-(CGFloat)percentThroughChapter:(NSInteger)c page:(NSInteger)p {
    NSArray * pages = self.chapters[[self key:c]];
    return (CGFloat) p / pages.count;
}

-(NSInteger)pageForChapter:(NSInteger)c percent:(CGFloat)percent {
    NSArray * pages = self.chapters[[self key:c]];
    return roundf(percent * pages.count);
}


@end
