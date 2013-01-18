// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.m instead.

#import "_File.h"

const struct FileAttributes FileAttributes = {
	.bookId = @"bookId",
	.ext = @"ext",
	.fileId = @"fileId",
	.name = @"name",
	.url = @"url",
};

const struct FileRelationships FileRelationships = {
	.book = @"book",
};

const struct FileFetchedProperties FileFetchedProperties = {
};

@implementation FileID
@end

@implementation _File

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"File";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"File" inManagedObjectContext:moc_];
}

- (FileID*)objectID {
	return (FileID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic bookId;






@dynamic ext;






@dynamic fileId;






@dynamic name;






@dynamic url;






@dynamic book;

	






@end
