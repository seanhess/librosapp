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
#import "FileDownloadOperation.h"
#import "NSArray+Functional.h"

@interface FileService ()
@end

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
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"bookId == %@", bookId];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError * error = nil;
    NSArray * files = [ObjectStore.shared.context executeFetchRequest:fetch error:&error];
    return files;
}

// you already have the files
// download them one at a time
-(void)downloadFiles:(NSArray *)files progress:(void (^)(float))progressCb complete:(void (^)(void))cb {
    NSOperationQueue * operations = [NSOperationQueue new];
    operations.maxConcurrentOperationCount = 1;
    __block NSInteger completedFiles = 0;
    
    [files forEach:^(File* file) {
        FileDownloadOperation * download = [FileDownloadOperation new];
        download.file = file;
        download.localPath = [self localPath:file];
        
        download.progressCb = ^(NSInteger complete, NSInteger total) {
            float progress = (completedFiles+((float)complete/total))/files.count;
            progressCb(progress);
        };
        
        download.completionBlock = ^{
            completedFiles++;
        };
        
        [operations addOperation:download];
    }];
    
    // will be called when we are done, since operations are "concurrent" (async)
    [operations addOperationWithBlock:^{
        cb();
    }];
}


// File getters
-(NSURL*)url:(File*)file {
    return [NSURL URLWithString:file.url];
}

-(NSString*)localPath:(File *)file {
    return [NSString stringWithFormat:@"%@/%@.%@", self.documentsDirectory, file.fileId, file.ext];
}

-(NSString*)readAsText:(File *)file {
    NSError * error = nil;
    return [NSString stringWithContentsOfFile:[self localPath:file] encoding:NSUTF8StringEncoding error:&error];
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

-(NSArray*)filterFiles:(NSArray*)files byFormat:(NSString*)format {
    return [files filter:^(File*file) {
        return [file.ext isEqualToString:format];
    }];
}

@end
