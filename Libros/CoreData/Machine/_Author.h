// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Author.h instead.

#import <CoreData/CoreData.h>


extern const struct AuthorAttributes {
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *name;
} AuthorAttributes;

extern const struct AuthorRelationships {
} AuthorRelationships;

extern const struct AuthorFetchedProperties {
} AuthorFetchedProperties;






@interface AuthorID : NSManagedObjectID {}
@end

@interface _Author : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AuthorID*)objectID;




@property (nonatomic, strong) NSString* firstName;


//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* lastName;


//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _Author (CoreDataGeneratedAccessors)

@end

@interface _Author (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
