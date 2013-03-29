//
//  Book.h
//  Libros
//
//  Created by Sean Hess on 3/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, User;

@interface Book : NSManagedObject

@property (nonatomic) int16_t audioFiles;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * bookId;
@property (nonatomic) int16_t currentChapter;
@property (nonatomic) int16_t currentPage;
@property (nonatomic) double currentTime;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic) float downloaded;
@property (nonatomic) BOOL featured;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic) int16_t popularity;
@property (nonatomic) BOOL purchased;
@property (nonatomic) int16_t textFiles;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) User *user;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
