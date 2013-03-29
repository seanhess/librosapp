//
//  BookService.h
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Book.h"

typedef enum {
    BookFilterEverything = 0,
    BookFilterHasText,
    BookFilterHasAudio
} BookFilter;

typedef enum {
    BookFormatText = 1,
    BookFormatAudio
} BookFormat;

@interface BookService : NSObject

+(BookService*)shared;
-(void)loadStore;
-(void)loadStoreWithCb:(void(^)(void))cb;

-(NSFetchRequest*)allBooks;
-(NSFetchRequest*)popular;
-(NSPredicate*)searchForText:(NSString*)text;

-(NSPredicate*)filterByType:(BookFilter)filter;

//-(NSString*)priceString:(Book*)book;
-(void)sendBookPurchased:(Book*)book;

-(NSArray*)firstRunBooks;



-(NSString*)productId:(Book*)book;      // In-App Purchase Product Id matching iTunes Connect

-(BOOL)isDownloading:(Book*)book;
-(BOOL)isDownloadComplete:(Book*)book;

@end
