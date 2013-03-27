// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <CoreData/CoreData.h>


extern const struct BookAttributes {
	__unsafe_unretained NSString *audioFiles;
	__unsafe_unretained NSString *author;
	__unsafe_unretained NSString *bookId;
	__unsafe_unretained NSString *currentChapter;
	__unsafe_unretained NSString *currentPage;
	__unsafe_unretained NSString *currentTime;
	__unsafe_unretained NSString *descriptionText;
	__unsafe_unretained NSString *downloaded;
	__unsafe_unretained NSString *featured;
	__unsafe_unretained NSString *genre;
	__unsafe_unretained NSString *imageUrl;
	__unsafe_unretained NSString *popularity;
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




@property (nonatomic, strong) NSNumber* currentChapter;


@property int16_t currentChapterValue;
- (int16_t)currentChapterValue;
- (void)setCurrentChapterValue:(int16_t)value_;

//- (BOOL)validateCurrentChapter:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* currentPage;


@property int16_t currentPageValue;
- (int16_t)currentPageValue;
- (void)setCurrentPageValue:(int16_t)value_;

//- (BOOL)validateCurrentPage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* currentTime;


@property double currentTimeValue;
- (double)currentTimeValue;
- (void)setCurrentTimeValue:(double)value_;

//- (BOOL)validateCurrentTime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* descriptionText;


//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* downloaded;


@property float downloadedValue;
- (float)downloadedValue;
- (void)setDownloadedValue:(float)value_;

//- (BOOL)validateDownloaded:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* featured;


@property BOOL featuredValue;
- (BOOL)featuredValue;
- (void)setFeaturedValue:(BOOL)value_;

//- (BOOL)validateFeatured:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* genre;


//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* imageUrl;


//- (BOOL)validateImageUrl:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* popularity;


@property int16_t popularityValue;
- (int16_t)popularityValue;
- (void)setPopularityValue:(int16_t)value_;

//- (BOOL)validatePopularity:(id*)value_ error:(NSError**)error_;




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




- (NSNumber*)primitiveCurrentChapter;
- (void)setPrimitiveCurrentChapter:(NSNumber*)value;

- (int16_t)primitiveCurrentChapterValue;
- (void)setPrimitiveCurrentChapterValue:(int16_t)value_;




- (NSNumber*)primitiveCurrentPage;
- (void)setPrimitiveCurrentPage:(NSNumber*)value;

- (int16_t)primitiveCurrentPageValue;
- (void)setPrimitiveCurrentPageValue:(int16_t)value_;




- (NSNumber*)primitiveCurrentTime;
- (void)setPrimitiveCurrentTime:(NSNumber*)value;

- (double)primitiveCurrentTimeValue;
- (void)setPrimitiveCurrentTimeValue:(double)value_;




- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;




- (NSNumber*)primitiveDownloaded;
- (void)setPrimitiveDownloaded:(NSNumber*)value;

- (float)primitiveDownloadedValue;
- (void)setPrimitiveDownloadedValue:(float)value_;




- (NSNumber*)primitiveFeatured;
- (void)setPrimitiveFeatured:(NSNumber*)value;

- (BOOL)primitiveFeaturedValue;
- (void)setPrimitiveFeaturedValue:(BOOL)value_;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSString*)primitiveImageUrl;
- (void)setPrimitiveImageUrl:(NSString*)value;




- (NSNumber*)primitivePopularity;
- (void)setPrimitivePopularity:(NSNumber*)value;

- (int16_t)primitivePopularityValue;
- (void)setPrimitivePopularityValue:(int16_t)value_;




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
