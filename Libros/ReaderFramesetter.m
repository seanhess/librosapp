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

#define FRAME_LEFT_OFFSET 15
#define FRAME_TOP_OFFSET 12
#define FRAME_RIGHT_OFFSET 15
#define FRAME_BOTTOM_OFFSET 10

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
    if (!text) {
        NSLog(@"NO TEXT for chapter %i", chapter);
        return [NSMutableArray array];
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    
    NSMutableArray * pages = [NSMutableArray array];
    // CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    // Coordinates are flipped or something. Top and bottom are swapped but not left and right. Coordinate system is bottom-left
    CGRect textFrame = CGRectMake(FRAME_LEFT_OFFSET, FRAME_BOTTOM_OFFSET, self.size.width-FRAME_RIGHT_OFFSET-FRAME_LEFT_OFFSET, self.size.height-FRAME_BOTTOM_OFFSET-FRAME_TOP_OFFSET);
    
    while(location < text.length) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, textFrame);
        
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
    if (![self hasPagesForChapter:chapter]) {
        NSLog(@"GENERATING PAGES %i", chapter);
        self.chapters[[self key:chapter]] = [self generatePagesForChapter:chapter];
    }
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
