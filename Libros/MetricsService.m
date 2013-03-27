//
//  MetricsService.m
//  Libros
//
//  Created by Sean Hess on 3/12/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "MetricsService.h"
#import <Mixpanel.h>

#define MIXPANEL_TOKEN @"35fb670992d7da530a907648513cdc79"

@implementation MetricsService

+(Mixpanel*)mixpanel {
    return [Mixpanel sharedInstance];
}

+(NSMutableDictionary*)bookProperties:(Book*)book {
    NSMutableDictionary * props = [NSMutableDictionary dictionary];
    props[@"bookId"] = book.bookId;
//    if (book.price)
//        props[@"price"] = book.price;
    if (book.purchased)
        props[@"purchased"] = book.purchased;
    if (book.currentChapter)
        props[@"currentChapter"] = book.currentChapter;
    return props;
}

+(void)launch {
    // initialize with token and send event
    // this should be called VERY FIRST so it goes to the right place
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    return [self.mixpanel track:@"launch"];
}

+(void)libraryLoad {
    [self.mixpanel track:@"library load"];
}

+(void)libraryListLayout {
    [self.mixpanel track:@"library layout" properties:@{@"layout": @"list"}];
}

+(void)libraryGridLayout {
    [self.mixpanel track:@"library layout" properties:@{@"layout": @"grid"}];
}



+(void)readerLoadedBook:(Book*)book {
    [self.mixpanel track:@"reader load" properties:[self bookProperties:book]];
}
+(void)readerTappedToc:(Book*)book {
    [self.mixpanel track:@"reader toc tap" properties:[self bookProperties:book]];
}
+(void)readerSwitchedTocChapter:(Book*)book chapter:(NSInteger)chapter {
    // meh, don't care
//    [self.mixpanel track:@"reader toc switch" properties:[self bookProperties:book]];
}
+(void)readerTappedFont {
    [self.mixpanel track:@"reader font tap"];
}
+(void)readerChangedFont:(ReaderFont)face size:(NSInteger)size {
    [self.mixpanel track:@"reader font change" properties:@{@"font":[NSNumber numberWithInt:face], @"size": [NSNumber numberWithInt:size]}];
}

+(void)readerPlayedAudio:(Book*)book {
    [self.mixpanel track:@"reader audio play" properties:[self bookProperties:book]];
}
+(void)readerChangedRate:(float)rate {
    [self.mixpanel track:@"reader audio rate" properties:@{@"rate":[NSNumber numberWithFloat:rate]}];
}

+(void)storePopularLoad {
    [self.mixpanel track:@"store popular"];
}
+(void)storeGenresLoad {
    [self.mixpanel track:@"store genres"];
}
+(void)storeAuthorsLoad {
    [self.mixpanel track:@"store authors"];
}
+(void)storeSearchLoad {
    [self.mixpanel track:@"store search"];
}

+(void)storeBookLoad:(Book*)book {
    [self.mixpanel track:@"store book load" properties:[self bookProperties:book]];
}
+(void)storeBookBeginBuy:(Book*)book {
    [self.mixpanel track:@"store book buy start" properties:[self bookProperties:book]];
}
+(void)storeBookFinishBuy:(Book*)book {
    [self.mixpanel track:@"store book buy finish" properties:[self bookProperties:book]];
}

+(void)storeBookBeginBuyAll {
    [self.mixpanel track:@"store buyall start"];
}

+(void)storeBookFinishBuyAll {
    [self.mixpanel track:@"store buyall finish"];
}

@end
