// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

const struct BookAttributes BookAttributes = {
	.author = @"author",
	.bookId = @"bookId",
	.descriptionText = @"descriptionText",
	.hasAudio = @"hasAudio",
	.hasText = @"hasText",
	.price = @"price",
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
	
	if ([key isEqualToString:@"hasAudioValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasAudio"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"hasTextValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasText"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic author;






@dynamic bookId;






@dynamic descriptionText;






@dynamic hasAudio;



- (BOOL)hasAudioValue {
	NSNumber *result = [self hasAudio];
	return [result boolValue];
}

- (void)setHasAudioValue:(BOOL)value_ {
	[self setHasAudio:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHasAudioValue {
	NSNumber *result = [self primitiveHasAudio];
	return [result boolValue];
}

- (void)setPrimitiveHasAudioValue:(BOOL)value_ {
	[self setPrimitiveHasAudio:[NSNumber numberWithBool:value_]];
}





@dynamic hasText;



- (BOOL)hasTextValue {
	NSNumber *result = [self hasText];
	return [result boolValue];
}

- (void)setHasTextValue:(BOOL)value_ {
	[self setHasText:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHasTextValue {
	NSNumber *result = [self primitiveHasText];
	return [result boolValue];
}

- (void)setPrimitiveHasTextValue:(BOOL)value_ {
	[self setPrimitiveHasText:[NSNumber numberWithBool:value_]];
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
