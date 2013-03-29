//
//  User.h
//  Libros
//
//  Created by Sean Hess on 3/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *books;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

@end
