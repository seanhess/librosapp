//
//  ReaderFrameCache.h
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReaderFormatter.h"

@interface ReaderFramesetter : NSObject

@property (nonatomic, strong) ReaderFormatter * formatter;
// Keep this up to date when your view changes size!
@property (nonatomic) CGRect bounds;

-(id)frameForChapter:(NSInteger)chapter page:(NSInteger)page;
-(NSInteger)pagesForChapter:(NSInteger)chapter;

-(void)emptyExceptChapter:(NSInteger)chapter;
-(void)empty;

-(void)ensureFramesForChapter:(NSInteger)chapter;

@end
