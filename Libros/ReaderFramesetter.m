//
//  ReaderFrameCache.m
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//


#import "ReaderFramesetter.h"
#import "ReaderFormatter.h"
#import <CoreText/CoreText.h>

#define FRAME_X_OFFSET 25
#define FRAME_Y_OFFSET 25

@interface ReaderFramesetter ()
@property (strong, nonatomic) NSMutableDictionary * chapters;
@end

@implementation ReaderFramesetter

-(NSMutableDictionary*)chapters {
    if (!_chapters) {
        self.chapters = [NSMutableDictionary dictionary];
    }
    
    return _chapters;
}

-(id<NSCopying>)key:(NSInteger)chapter {
    return [NSNumber numberWithInteger:chapter];
}

-(void)setFrames:(NSArray *)frames forChapter:(NSInteger)chapter {
    self.chapters[[self key:chapter]] = frames;
}

-(BOOL)hasFramesForChapter:(NSInteger)chapter {
    if (chapter < self.chapters.count && self.chapters[[self key:chapter]]) return YES;
    return NO;
}

-(id)frameForChapter:(NSInteger)chapter page:(NSInteger)page {
    return self.chapters[[self key:chapter]][page];
}

-(NSInteger)pagesForChapter:(NSInteger)chapter {
    return [self.chapters[[self key:chapter]] count];
}

-(void)emptyExceptChapter:(NSInteger)chapter {
    NSMutableDictionary * newChapters = [NSMutableDictionary dictionary];
    newChapters[[self key:chapter]] = self.chapters[[self key:chapter]];
    self.chapters = newChapters;
}

-(NSMutableArray*)generateFramesForChapter:(NSInteger)chapter {
    NSInteger location = 0;
    
    NSAttributedString * text = [self.formatter textForChapter:chapter];
    NSLog(@"TEXT %i", text.length);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    
    NSMutableArray * frames = [NSMutableArray array];
    
    while(location < text.length) {
        NSLog(@"GENERATING for chapter=%i location=%i", chapter, location);
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect insetFrame = CGRectInset(self.bounds, FRAME_X_OFFSET, FRAME_Y_OFFSET);
        CGPathAddRect(path, NULL, insetFrame);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(location, 0), path, NULL);
        [frames addObject:(__bridge id)frame];
        location += CTFrameGetVisibleStringRange(frame).length;
        CFRelease(frame);
        CFRelease(path);
    }
    
    CFRelease(framesetter);
    
    return frames;
}

// if the frames don't exist, generate them!
-(void)ensureFramesForChapter:(NSInteger)chapter {
    if (![self hasFramesForChapter:chapter])
        [self setFrames:[self generateFramesForChapter:chapter] forChapter:chapter];
}

@end
