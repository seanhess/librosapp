//
//  AuthorService.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "AuthorService.h"
#import <RestKit/RestKit.h>
#import "Author.h"
#import "NSObject+Reflection.h"
#import "ObjectStore.h"
#import "BookService.h"

@implementation AuthorService

+ (AuthorService *)shared
{
    static AuthorService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AuthorService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"Author"];
    [bookMapping setIdentificationAttributes:@[@"name"]];
    [bookMapping addAttributeMappingsFromArray:[_Author propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/authors" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [ObjectStore.shared syncWithFetchRequest:self.allAuthors forPath:@"/authors"];
}

-(void)load {
    [[ObjectStore shared].objectManager getObjectsAtPath:@"/authors" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

-(NSFetchRequest*)allAuthors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]
    ];
    return fetchRequest;
}

-(NSFetchRequest*)booksByAuthor:(NSString*)author {
    NSFetchRequest *fetchRequest = [[BookService shared] popular];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"author == %@", author];
    fetchRequest.predicate = predicate;
    return fetchRequest;
}

-(NSPredicate*)searchForText:(NSString*)text {
    return [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", [text lowercaseString]];
}

@end
