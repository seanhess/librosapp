// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

const struct BookAttributes BookAttributes = {
	.audioFiles = @"audioFiles",
	.author = @"author",
	.bookId = @"bookId",
	.currentChapter = @"currentChapter",
	.currentPage = @"currentPage",
	.currentTime = @"currentTime",
	.descriptionText = @"descriptionText",
	.downloaded = @"downloaded",
	.genre = @"genre",
	.imageUrl = @"imageUrl",
	.popularity = @"popularity",
	.purchased = @"purchased",
	.textFiles = @"textFiles",
	.title = @"title",
};

const struct BookRelationships BookRelationships = {
	.files = @"files",
	.user = @"user",
};

const struct BookFetchedProperties BookFetchedProperties = {
};

@implementation BookID
@end

@implementation _Book

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Book";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:moc_];
}

- (BookID*)objectID {
	return (BookID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"audioFilesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"audioFiles"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"currentChapterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentChapter"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"currentPageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentPage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"currentTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"downloadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"downloaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"popularityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"popularity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"purchasedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"purchased"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"textFilesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"textFiles"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic audioFiles;



- (int16_t)audioFilesValue {
	NSNumber *result = [self audioFiles];
	return [result shortValue];
}

- (void)setAudioFilesValue:(int16_t)value_ {
	[self setAudioFiles:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveAudioFilesValue {
	NSNumber *result = [self primitiveAudioFiles];
	return [result shortValue];
}

- (void)setPrimitiveAudioFilesValue:(int16_t)value_ {
	[self setPrimitiveAudioFiles:[NSNumber numberWithShort:value_]];
}





@dynamic author;






@dynamic bookId;






@dynamic currentChapter;



- (int16_t)currentChapterValue {
	NSNumber *result = [self currentChapter];
	return [result shortValue];
}

- (void)setCurrentChapterValue:(int16_t)value_ {
	[self setCurrentChapter:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCurrentChapterValue {
	NSNumber *result = [self primitiveCurrentChapter];
	return [result shortValue];
}

- (void)setPrimitiveCurrentChapterValue:(int16_t)value_ {
	[self setPrimitiveCurrentChapter:[NSNumber numberWithShort:value_]];
}





@dynamic currentPage;



- (int16_t)currentPageValue {
	NSNumber *result = [self currentPage];
	return [result shortValue];
}

- (void)setCurrentPageValue:(int16_t)value_ {
	[self setCurrentPage:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCurrentPageValue {
	NSNumber *result = [self primitiveCurrentPage];
	return [result shortValue];
}

- (void)setPrimitiveCurrentPageValue:(int16_t)value_ {
	[self setPrimitiveCurrentPage:[NSNumber numberWithShort:value_]];
}





@dynamic currentTime;



- (double)currentTimeValue {
	NSNumber *result = [self currentTime];
	return [result doubleValue];
}

- (void)setCurrentTimeValue:(double)value_ {
	[self setCurrentTime:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveCurrentTimeValue {
	NSNumber *result = [self primitiveCurrentTime];
	return [result doubleValue];
}

- (void)setPrimitiveCurrentTimeValue:(double)value_ {
	[self setPrimitiveCurrentTime:[NSNumber numberWithDouble:value_]];
}





@dynamic descriptionText;






@dynamic downloaded;



- (float)downloadedValue {
	NSNumber *result = [self downloaded];
	return [result floatValue];
}

- (void)setDownloadedValue:(float)value_ {
	[self setDownloaded:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDownloadedValue {
	NSNumber *result = [self primitiveDownloaded];
	return [result floatValue];
}

- (void)setPrimitiveDownloadedValue:(float)value_ {
	[self setPrimitiveDownloaded:[NSNumber numberWithFloat:value_]];
}





@dynamic genre;






@dynamic imageUrl;






@dynamic popularity;



- (int16_t)popularityValue {
	NSNumber *result = [self popularity];
	return [result shortValue];
}

- (void)setPopularityValue:(int16_t)value_ {
	[self setPopularity:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePopularityValue {
	NSNumber *result = [self primitivePopularity];
	return [result shortValue];
}

- (void)setPrimitivePopularityValue:(int16_t)value_ {
	[self setPrimitivePopularity:[NSNumber numberWithShort:value_]];
}





@dynamic purchased;



- (BOOL)purchasedValue {
	NSNumber *result = [self purchased];
	return [result boolValue];
}

- (void)setPurchasedValue:(BOOL)value_ {
	[self setPurchased:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePurchasedValue {
	NSNumber *result = [self primitivePurchased];
	return [result boolValue];
}

- (void)setPrimitivePurchasedValue:(BOOL)value_ {
	[self setPrimitivePurchased:[NSNumber numberWithBool:value_]];
}





@dynamic textFiles;



- (int16_t)textFilesValue {
	NSNumber *result = [self textFiles];
	return [result shortValue];
}

- (void)setTextFilesValue:(int16_t)value_ {
	[self setTextFiles:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTextFilesValue {
	NSNumber *result = [self primitiveTextFiles];
	return [result shortValue];
}

- (void)setPrimitiveTextFilesValue:(int16_t)value_ {
	[self setPrimitiveTextFiles:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic files;

	
- (NSMutableSet*)filesSet {
	[self willAccessValueForKey:@"files"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"files"];
  
	[self didAccessValueForKey:@"files"];
	return result;
}
	

@dynamic user;

	






@end
