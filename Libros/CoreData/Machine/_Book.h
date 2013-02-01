// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <CoreData/CoreData.h>


extern const struct BookAttributes {
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *bookId;
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *genre;
	__unsafe_unretained NSString *hasAudio;
	__unsafe_unretained NSString *hasText;
	__unsafe_unretained NSString *price;
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




@property (nonatomic, strong) NSString* author;


//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* bookId;


//- (BOOL)validateBookId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* descriptionText;


//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* genre;


//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* hasAudio;


@property BOOL hasAudioValue;
- (BOOL)hasAudioValue;
- (void)setHasAudioValue:(BOOL)value_;

//- (BOOL)validateHasAudio:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* hasText;


@property BOOL hasTextValue;
- (BOOL)hasTextValue;
- (void)setHasTextValue:(BOOL)value_;

//- (BOOL)validateHasText:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* price;


@property int16_t priceValue;
- (int16_t)priceValue;
- (void)setPriceValue:(int16_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;




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


- (NSString*)primitiveAuthor;
- (void)setPrimitiveAuthor:(NSString*)value;




- (NSString*)primitiveBookId;
- (void)setPrimitiveBookId:(NSString*)value;




- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSNumber*)primitiveHasAudio;
- (void)setPrimitiveHasAudio:(NSNumber*)value;

- (BOOL)primitiveHasAudioValue;
- (void)setPrimitiveHasAudioValue:(BOOL)value_;




- (NSNumber*)primitiveHasText;
- (void)setPrimitiveHasText:(NSNumber*)value;

- (BOOL)primitiveHasTextValue;
- (void)setPrimitiveHasTextValue:(BOOL)value_;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int16_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveFiles;
- (void)setPrimitiveFiles:(NSMutableSet*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
