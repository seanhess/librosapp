//
//  UserService.m
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UserService.h"
#import "ObjectStore.h"
#import "User.h"
#import "NSObject+Reflection.h"

#import <RestKit.h>

@implementation UserService

+ (UserService *)shared
{
    static UserService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserService alloc] init];
        [instance initMappings];
        [instance initMainUser];
    });
    return instance;
}

- (void)initMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"User"];
    [bookMapping setIdentificationAttributes:@[@"userId"]];
    [bookMapping addAttributeMappingsFromArray:[_User propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/books" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
}

- (void)initMainUser {

    // There's only one in the whole system!
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetch.fetchLimit = 1;
    NSError * error = nil;
    NSArray * users = [ObjectStore.shared.context executeFetchRequest:fetch error:&error];
    
    if (users.count) {
        self.main = users[0];
    }
    
    else {
        User * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:ObjectStore.shared.context];
        user.userId = @"main";
        self.main = user;
    }
}

-(void)addBook:(Book *)book {
    [self.main addBooksObject:book];
}

@end
