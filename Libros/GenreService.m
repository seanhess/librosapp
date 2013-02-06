//
//  GenreService.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "GenreService.h"
#import <RestKit/RestKit.h>
#import "Genre.h"
#import "NSObject+Reflection.h"
#import "ObjectStore.h"
#import "BookService.h"

@implementation GenreService

+ (GenreService *)shared
{
    static GenreService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GenreService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"Genre"];
    [bookMapping setIdentificationAttributes:@[@"name"]];
    [bookMapping addAttributeMappingsFromArray:[_Genre propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/genres" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [ObjectStore.shared syncWithFetchRequest:self.allGenres forPath:@"/genres"];
    
}

-(void)load {
    [[ObjectStore shared].objectManager getObjectsAtPath:@"/genres" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

-(NSFetchRequest*)allGenres {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Genre"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    return fetchRequest;
}

-(NSFetchRequest*)booksByGenre:(NSString*)genre {
    NSFetchRequest *fetchRequest = [[BookService shared] popular];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"genre == %@", genre];
    fetchRequest.predicate = predicate;
    return fetchRequest;
}

@end
