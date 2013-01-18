//
//  FileService.m
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "FileService.h"
#import <RestKit/RestKit.h>
#import "ObjectStore.h"
#import "File.h"
#import "NSObject+Reflection.h"

@implementation FileService

+ (FileService *)shared
{
    static FileService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FileService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *bookMapping = [ObjectStore.shared mappingForEntityForName:@"File"];
    [bookMapping setIdentificationAttributes:@[@"fileId"]];
    [bookMapping addAttributeMappingsFromArray:[_File propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:bookMapping pathPattern:@"/books/:bookId/files" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
}

-(void)loadFilesForBook:(NSString *)bookId cb:(void (^)(void))cb {
    NSString * url = [NSString stringWithFormat:@"/books/%@/files", bookId];
    [[ObjectStore shared].objectManager getObjectsAtPath:url parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        cb();
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

-(NSArray*)byBookId:(NSString *)bookId {
    
    // There's only one in the whole system!
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"bookId == %@", bookId];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError * error = nil;
    NSArray * files = [ObjectStore.shared.context executeFetchRequest:fetch error:&error];
    return files;
}


// Once you already HAVE the files
-(void)downloadFiles:(NSArray*)files cb:(void(^)(void))cb {
    NSLog(@"DOWNLOADING FILES %i", files.count);
    // TODO move to background thread
    for (File * file in files) {
        [self downloadFileSync:file];
    }
    
    NSLog(@"DONE");
    cb();
}


// File getters
-(NSURL*)url:(File*)file {
    return [NSURL URLWithString:file.url];
}

-(NSString*)localPath:(File *)file {
    return [NSString stringWithFormat:@"%@/%@", self.documentsDirectory, @"filename.png"];
}



-(NSString*)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)downloadFileSync:(File*)file {
    NSError * error = nil;
    NSData * data = [NSData dataWithContentsOfURL:[self url:file] options:NSDataReadingMapped error:&error];
    
    if (data) {
        [data writeToFile:[self localPath:file] atomically:YES];
    }
}

@end
