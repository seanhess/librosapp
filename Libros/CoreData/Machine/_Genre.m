// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Genre.m instead.

#import "_Genre.h"

const struct GenreAttributes GenreAttributes = {
	.name = @"name",
};

const struct GenreRelationships GenreRelationships = {
};

const struct GenreFetchedProperties GenreFetchedProperties = {
};

@implementation GenreID
@end

@implementation _Genre

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Genre";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:moc_];
}

- (GenreID*)objectID {
	return (GenreID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;











@end
