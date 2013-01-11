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

@implementation BookService

+(void)initialBooks:(void(^)(NSArray*))cb {
    [[ObjectStore shared].objectManager getObjectsAtPath:@"/books/initial/" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        NSLog(@"SUCCESS %@ %@", operation, mappingResult);
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

//+(void)installInitialBooks:(void(^)(void)) {
//    [self initialBooks:(NSArray*books) {
//        
//    }];
//}
                                     
                                     

+(void)myBooks:(void (^)(NSArray *))cb {
    
//    [self initialBooks:cb];
    cb(@[]);
    
//    return;
//    NSError * error = nil;
//    NSFetchRequest * request = [self request];
//    NSArray * books = [context executeFetchRequest:request error:&error];
//    cb(books);
}



@end
