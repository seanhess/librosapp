//
//  ReaderFrameCache.m
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderFrameCache.h"

@interface ReaderFrameCache ()
@property (strong, nonatomic) NSMutableArray * chapters;
@end

@implementation ReaderFrameCache

-(NSMutableArray*)chapters {
    if (!_chapters) {
        self.chapters = [NSMutableArray array];
    }
    
    return _chapters;
}

-(void)setFrames:(NSArray *)frames forChapter:(NSInteger)chapter {
    self.chapters[chapter] = frames;
}

-(BOOL)hasFramesForChapter:(NSInteger)chapter {
    if (chapter < self.chapters.count && self.chapters[chapter]) return YES;
    return NO;
}

-(id)frameForChapter:(NSInteger)chapter page:(NSInteger)page {
    return self.chapters[chapter][page];
}

-(NSInteger)pagesForChapter:(NSInteger)chapter {
    return [self.chapters[chapter] count];
}

-(void)emptyExceptChapter:(NSInteger)chapter {
    NSMutableArray * newChapters = [NSMutableArray array];
    newChapters[chapter] = self.chapters[chapter];
    self.chapters = newChapters;
}

@end
