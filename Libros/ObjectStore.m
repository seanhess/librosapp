//
//  ObjectStore.m
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//
// I need to store some stuff
// it needs to know the application directory
// so a singleton with some initialization

#import "ObjectStore.h"
#import "Settings.h"

@interface ObjectStore()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end




@implementation ObjectStore

@synthesize managedObjectModel = _managedObjectModel;

+ (ObjectStore *)shared
{
    static ObjectStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ObjectStore alloc] init];
        [sharedInstance initObjectManager];
    });
    return sharedInstance;
}

- (void)initObjectManager {
    
    NSLog(@"ENDPOINT = %@", API_ENDPOINT);
    
    // Core Data Example
    // Initialize RestKIT
    self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_ENDPOINT]];
    self.objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.objectManager.managedObjectStore = self.objectStore;
    
    // Other Initialization (move this to app delegate)
    [self.objectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Libros.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error;
    if (![self.objectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error]) {
        NSLog(@"Problem with Persistent Store Coordinator %@", error);
        NSAssert(NO, @"failed to add persistent store");
    }
    
    [self.objectStore createManagedObjectContexts];
    
    self.objectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.context];
}

// some demeters law, don't access the store and stuff, just add them here.
// See BookService for usage
- (RKEntityMapping *)mappingForEntityForName:(NSString *)entityName {
    return [RKEntityMapping mappingForEntityForName:entityName inManagedObjectStore:self.objectStore];
}

- (void)addResponseDescriptor:(RKResponseDescriptor *)descriptor {
    [self.objectManager addResponseDescriptor:descriptor];
}

- (void)syncWithFetchRequest:(NSFetchRequest *)request forPath:(NSString *)path {
    [self.objectManager addFetchRequestBlock:^(NSURL* url) {
        RKPathMatcher * matcher = [RKPathMatcher pathMatcherWithPattern:path];
        NSFetchRequest * matchingRequest = nil;
        BOOL match = [matcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        if (match) {
            matchingRequest = request;
        }
        return matchingRequest;
    }];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Libros" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)context {
    // the mainQueueManagedObjectContext is a child of this one, but it doesn't persist. I'm not exactly sure what it is for.
    // either way, we need to use this one if we want things to save
    return self.objectStore.persistentStoreManagedObjectContext;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


@end
