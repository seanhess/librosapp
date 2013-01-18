// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.h instead.

#import <CoreData/CoreData.h>


extern const struct FileAttributes {
	__unsafe_unretained NSString *bookId;
	__unsafe_unretained NSString *ext;
	__unsafe_unretained NSString *fileId;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *url;
} FileAttributes;

extern const struct FileRelationships {
	__unsafe_unretained NSString *book;
} FileRelationships;

extern const struct FileFetchedProperties {
} FileFetchedProperties;

@class Book;







@interface FileID : NSManagedObjectID {}
@end

@interface _File : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FileID*)objectID;




@property (nonatomic, strong) NSString* bookId;


//- (BOOL)validateBookId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* ext;


//- (BOOL)validateExt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* fileId;


//- (BOOL)validateFileId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* url;


//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Book* book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;





@end

@interface _File (CoreDataGeneratedAccessors)

@end

@interface _File (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBookId;
- (void)setPrimitiveBookId:(NSString*)value;




- (NSString*)primitiveExt;
- (void)setPrimitiveExt:(NSString*)value;




- (NSString*)primitiveFileId;
- (void)setPrimitiveFileId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;


@end
