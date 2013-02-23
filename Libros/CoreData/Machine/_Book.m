// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

const struct BookAttributes BookAttributes = {
	.audioFiles = @"audioFiles",
	.author = @"author",
	.bookId = @"bookId",
	.descriptionText = @"descriptionText",
	.downloaded = @"downloaded",
	.genre = @"genre",
	.imageUrl = @"imageUrl",
	.preferredFormat = @"preferredFormat",
	.price = @"price",
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
	if ([key isEqualToString:@"downloadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"downloaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"preferredFormatValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"preferredFormat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
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






@dynamic preferredFormat;



- (int16_t)preferredFormatValue {
	NSNumber *result = [self preferredFormat];
	return [result shortValue];
}

- (void)setPreferredFormatValue:(int16_t)value_ {
	[self setPreferredFormat:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePreferredFormatValue {
	NSNumber *result = [self primitivePreferredFormat];
	return [result shortValue];
}

- (void)setPrimitivePreferredFormatValue:(int16_t)value_ {
	[self setPrimitivePreferredFormat:[NSNumber numberWithShort:value_]];
}





@dynamic price;



- (int16_t)priceValue {
	NSNumber *result = [self price];
	return [result shortValue];
}

- (void)setPriceValue:(int16_t)value_ {
	[self setPrice:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result shortValue];
}

- (void)setPrimitivePriceValue:(int16_t)value_ {
	[self setPrimitivePrice:[NSNumber numberWithShort:value_]];
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
