//
//  BookService.m
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "BookService.h"
#import "Book.h"
#import <RestKit/RestKit.h>
#import "ObjectStore.h"
#import "NSObject+Reflection.h"

@interface BookService ()
@end



@implementation BookService

+ (BookService *)shared
{
    static BookService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"Book"];
    [bookMapping setIdentificationAttributes:@[@"bookId"]];
    
    NSMutableArray * propertyNames = [NSMutableArray arrayWithArray:[_Book propertyNames]];
    NSIndexSet * indices = [propertyNames indexesOfObjectsPassingTest:^(NSString * name, NSUInteger idx, BOOL * stop) {
        return [name isEqualToString:@"descriptionText"];
    }];
    [propertyNames removeObjectsAtIndexes:indices];
    
    [bookMapping addAttributeMappingsFromArray:propertyNames];
    [bookMapping addAttributeMappingsFromDictionary:@{@"description": @"descriptionText"}];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/books" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
}


// So you can compose with compoundPredicates. Wahoo.
// Or just let the dumb view controllers do whatever they want. it's not THAT bad
// not that great either

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request

-(void)loadStore {
    [[ObjectStore shared].objectManager getObjectsAtPath:@"/books" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

//+(void)installInitialBooks:(void(^)(void)) {
//    [self initialBooks:(NSArray*books) {
//        
//    }];
//}

-(void)myBooks:(void (^)(NSArray *))cb {
    
//    [self initialBooks:cb];
    cb(@[]);
    
//    return;
//    NSError * error = nil;
//    NSFetchRequest * request = [self request];
//    NSArray * books = [context executeFetchRequest:request error:&error];
//    cb(books);
}

@end
