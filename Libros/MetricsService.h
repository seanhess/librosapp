//
//  MetricsService.h
//  Libros
//
//  Created by Sean Hess on 3/12/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "ReaderFormatter.h"

@interface MetricsService : NSObject

+(void)launch;

+(void)libraryLoad;

+(void)libraryListLayout;
+(void)libraryGridLayout;

+(void)readerLoadedBook:(Book*)book;
+(void)readerTappedToc:(Book*)book;
+(void)readerSwitchedTocChapter:(Book*)book chapter:(NSInteger)chapter;
+(void)readerTappedFont;
+(void)readerChangedFont:(ReaderFont)face size:(NSInteger)size;

+(void)readerPlayedAudio:(Book*)book;
+(void)readerChangedRate:(float)rate;

+(void)storePopularLoad;
+(void)storeGenresLoad;
+(void)storeAuthorsLoad;
+(void)storeSearchLoad;

+(void)storeBookLoad:(Book*)book;
+(void)storeBookBeginBuy:(Book*)book;
+(void)storeBookFinishBuy:(Book*)book;

+(void)storeBookBeginBuyAll;
+(void)storeBookFinishBuyAll;

@end
