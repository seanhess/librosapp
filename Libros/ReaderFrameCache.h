//
//  ReaderFrameCache.h
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReaderFrameCache : NSObject

-(void)setFrames:(NSArray*)frames forChapter:(NSInteger)chapter;
-(BOOL)hasFramesForChapter:(NSInteger)chapter;


-(id)frameForChapter:(NSInteger)chapter page:(NSInteger)page;
-(NSInteger)pagesForChapter:(NSInteger)chapter;

-(void)emptyExceptChapter:(NSInteger)chapter;

@end
