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
#import "Book.h"
#import "NSObject+Reflection.h"
#import "FileService.h"

#import <RestKit.h>

@interface UserService ()
@property (strong, nonatomic) Book * book;

@end

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

// use key-value observing instead of 
-(void)addBook:(Book *)book {
    book.purchasedValue = YES;
    book.downloadedValue = 0.0;
    
    [FileService.shared
        downloadFiles:[FileService.shared byBookId:book.bookId]
        progress:^(float percent) {
            book.downloadedValue = percent;
        }
        complete:^() {
            book.downloadedValue = 1.0;
        }
    ];
}

-(void)archiveBook:(Book *)book {
    book.purchasedValue = NO;
    book.downloadedValue = 0.0;
    FileService * fs = [FileService shared];
    [fs removeFiles:[fs byBookId:book.bookId]];
}


-(NSFetchRequest*)libraryBooks {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"purchased == YES"];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[descriptor];
    return fetchRequest;
}


@end
