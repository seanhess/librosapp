// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

const struct BookAttributes BookAttributes = {
	.bookId = @"bookId",
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
	

	return keyPaths;
}




@dynamic bookId;






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
