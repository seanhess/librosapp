//
//  UserService.m
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UserService.h"
#import "ObjectStore.h"

@implementation UserService

+(NSManagedObjectContext*)context {
    return nil; //ObjectStore.shared.managedObjectContext;
}

+(User*)main {
    if (!ObjectStore.shared.mainUser) {
        // There's only one in the whole system!
        NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        fetch.fetchLimit = 1;
        NSError * error = nil;
        NSArray * users = [self.context executeFetchRequest:fetch error:&error];
        
        if (users.count) {
            ObjectStore.shared.mainUser = users[0];
        }
        
        else {
            ObjectStore.shared.mainUser = [self createMainUser];
        }
    }
    
    return ObjectStore.shared.mainUser;
}

+(User*)createMainUser {
    User * user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
    user.userId = @"main";
    return user;
}

+(void)addBook:(Book *)book {
    User * main = self.main;
    NSLog(@"MAIN USER %@", main);
}

@end
