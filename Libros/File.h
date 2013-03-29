//
//  File.h
//  Libros
//
//  Created by Sean Hess on 3/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * bookId;
@property (nonatomic, retain) NSString * ext;
@property (nonatomic, retain) NSString * fileId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Book *book;

@end
