//
//  UserService.h
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "User.h"
#import "ReaderFormatter.h"

@interface UserService : NSObject

@property (nonatomic, strong) User * main;

@property (nonatomic) ReaderFont fontFace;
@property (nonatomic) NSInteger fontSize;

+(UserService*)shared;
-(User*)main;

-(void)addBook:(Book*)book;
-(void)addBooks:(NSArray*)books;
-(void)archiveBook:(Book*)book;

-(BOOL)hasActiveDownload;
-(BOOL)hasFirstLaunchBooks;
-(void)setHasFirstLaunchBooks;

-(void)purchasedAllBooks;
-(BOOL)hasPurchasedBook:(Book*)book;
-(void)setHasPurchasedBook:(Book*)book;

-(NSFetchRequest*)libraryBooks;

-(void)checkRestartDownload:(Book*)book;

@end

