// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <CoreData/CoreData.h>


extern const struct BookAttributes {
	__unsafe_unretained NSString *audioFiles;
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *bookId;
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *downloaded;
	__unsafe_unretained NSString *genre;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *purchased;
	__unsafe_unretained NSString *textFiles;
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




@property (nonatomic, strong) NSNumber* audioFiles;


@property int16_t audioFilesValue;
- (int16_t)audioFilesValue;
- (void)setAudioFilesValue:(int16_t)value_;

//- (BOOL)validateAudioFiles:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* author;


//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* bookId;


//- (BOOL)validateBookId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* descriptionText;


//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* downloaded;


@property float downloadedValue;
- (float)downloadedValue;
- (void)setDownloadedValue:(float)value_;

//- (BOOL)validateDownloaded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* genre;


//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* price;


@property int16_t priceValue;
- (int16_t)priceValue;
- (void)setPriceValue:(int16_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* purchased;


@property BOOL purchasedValue;
- (BOOL)purchasedValue;
- (void)setPurchasedValue:(BOOL)value_;

//- (BOOL)validatePurchased:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* textFiles;


@property int16_t textFilesValue;
- (int16_t)textFilesValue;
- (void)setTextFilesValue:(int16_t)value_;

//- (BOOL)validateTextFiles:(id*)value_ error:(NSError**)error_;




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


- (NSNumber*)primitiveAudioFiles;
- (void)setPrimitiveAudioFiles:(NSNumber*)value;

- (int16_t)primitiveAudioFilesValue;
- (void)setPrimitiveAudioFilesValue:(int16_t)value_;




- (NSString*)primitiveAuthor;
- (void)setPrimitiveAuthor:(NSString*)value;




- (NSString*)primitiveBookId;
- (void)setPrimitiveBookId:(NSString*)value;




- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;




- (NSNumber*)primitiveDownloaded;
- (void)setPrimitiveDownloaded:(NSNumber*)value;

- (float)primitiveDownloadedValue;
- (void)setPrimitiveDownloadedValue:(float)value_;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int16_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int16_t)value_;




- (NSNumber*)primitivePurchased;
- (void)setPrimitivePurchased:(NSNumber*)value;

- (BOOL)primitivePurchasedValue;
- (void)setPrimitivePurchasedValue:(BOOL)value_;




- (NSNumber*)primitiveTextFiles;
- (void)setPrimitiveTextFiles:(NSNumber*)value;

- (int16_t)primitiveTextFilesValue;
- (void)setPrimitiveTextFilesValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveFiles;
- (void)setPrimitiveFiles:(NSMutableSet*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
