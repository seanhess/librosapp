// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *userId;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *books;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class Book;



@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;




@property (nonatomic, strong) NSString* userId;


//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* books;

- (NSMutableSet*)booksSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(Book*)value_;
- (void)removeBooksObject:(Book*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(NSString*)value;





- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;


@end
