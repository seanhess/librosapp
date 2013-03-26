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
    self.fileMapping = [ObjectStore.shared mappingForEntityForName:@"File"];
    [self.fileMapping setIdentificationAttributes:@[@"fileId"]];
    [self.fileMapping addAttributeMappingsFromArray:[_File propertyNames]];
    
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.fileMapping pathPattern:@"/books/:bookId/files" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [ObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [ObjectStore.shared.objectManager addFetchRequestBlock:^(NSURL* url) {
        RKPathMatcher * matcher = [RKPathMatcher pathMatcherWithPattern:@"/books/:bookId/files"];
        NSFetchRequest * matchingRequest = nil;
        NSDictionary * args;
        BOOL match = [matcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:&args];
        if (match) {
            NSString * bookId = args[@"bookId"];
            matchingRequest = [self byBookIdRequest:bookId];
        }
        return matchingRequest;
    }];
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
    NSFetchRequest * fetch = [self byBookIdRequest:bookId];
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError * error = nil;
    NSArray * files = [ObjectStore.shared.context executeFetchRequest:fetch error:&error];
    return files;
}

-(NSFetchRequest*)byBookIdRequest:(NSString*)bookId {
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"File"];
    fetch.predicate = [NSPredicate predicateWithFormat:@"bookId == %@", bookId];
    return fetch;
}

// you already have the files
// download them one at a time
-(NSOperationQueue*)downloadFiles:(NSArray *)files progress:(void (^)(float))progressCb complete:(void (^)(void))cb {
    NSOperationQueue * operations = [NSOperationQueue new];
    operations.maxConcurrentOperationCount = 1;
    __block NSInteger completedFiles = 0;
    
    // during a mistake, some bad files got in there. Just add one more system that can catch it
    NSArray * validFiles = [files filter:^(File*file) {
        return (BOOL)(file.url != nil);
    }];
    
    [validFiles forEach:^(File* file) {
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
    
    return operations;
}


// File getters
-(NSURL*)url:(File*)file {
    return [NSURL URLWithString:file.url];
}

-(NSString*)localPath:(File *)file {
    return [NSString stringWithFormat:@"%@/%@.%@", self.documentsDirectory, file.fileId, file.ext];
}

-(LBParsedString*)readAsText:(File *)file {
    NSData * data = [self readAsData:file];
    LBParsedString * string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return string;
}

-(NSData*)readAsData:(File *)file {
    return [NSData dataWithContentsOfFile:[self localPath:file] options:NSDataReadingMapped error:nil];
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

-(NSArray*)textFiles:(NSArray*)array {
    return [self filterFiles:array byFormat:FileFormatText];
}

-(NSArray*)audioFiles:(NSArray*)array {
    return [self filterFiles:array byFormat:FileFormatAudio];
}

-(BOOL)isFile:(File *)file format:(NSString *)format {
    return [file.ext isEqualToString:format];
}

-(void)removeFiles:(NSArray*)files {
    [files forEach:^(File*file) {
        NSString * localPath = [self localPath:file];
        [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
    }];
}

-(NSArray*)chaptersForFiles:(NSArray*)files {
    NSMutableArray * chapters = [NSMutableArray array];
    Chapter * chapter = nil;
    
    for (File * file in files) {
        if (![file.name isEqualToString:chapter.name]) {
            chapter = [Chapter new];
            chapter.name = file.name;
            [chapters addObject:chapter];
        }
        if ([self isFile:file format:FileFormatAudio])
            chapter.audioFile = file;
        else if ([self isFile:file format:FileFormatText])
            chapter.textFile = file;
    }
    
    return chapters;
}


@end
