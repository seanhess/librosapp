// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <CoreData/CoreData.h>


extern const struct BookAttributes {
	__unsafe_unretained NSString *bookId;
	__unsafe_unretained NSString *title;
} BookAttributes;

extern const struct BookRelationships {
	__unsafe_unretained NSString *files;
	__unsafe_unretained NSString *user;
} BookRelationships;

extern const struct BookFetchedProperties {
} BookFetchedProperties;

@class File;
@class User;




@interface BookID : NSManagedObjectID {}
@end

@interface _Book : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BookID*)objectID;




@property (nonatomic, strong) NSString* bookId;


//- (BOOL)validateBookId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* title;


//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* files;

- (NSMutableSet*)filesSet;




@property (nonatomic, strong) User* user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Book (CoreDataGeneratedAccessors)

- (void)addFiles:(NSSet*)value_;
- (void)removeFiles:(NSSet*)value_;
- (void)addFilesObject:(File*)value_;
- (void)removeFilesObject:(File*)value_;

@end

@interface _Book (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBookId;
- (void)setPrimitiveBookId:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveFiles;
- (void)setPrimitiveFiles:(NSMutableSet*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
