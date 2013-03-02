//
//  FileService.h
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "File.h"
#import "LBParsedString.h"

#define FileFormatText @"html"
#define FileFormatAudio @"mp3"

@interface FileService : NSObject

+(FileService*)shared;

@property (nonatomic, strong) RKEntityMapping * fileMapping;

-(void)loadFilesForBook:(NSString*)bookId cb:(void(^)(void))cb;
-(void)downloadFiles:(NSArray*)files progress:(void(^)(float))cb complete:(void(^)(void))cb;

-(NSArray*)byBookId:(NSString*)bookId;

-(NSURL*)url:(File*)file;
-(NSString*)localPath:(File*)file;
-(LBParsedString*)readAsText:(File*)file;
-(NSData*)readAsData:(File*)file;

-(NSArray*)filterFiles:(NSArray*)array byFormat:(NSString*)format;
-(NSArray*)textFiles:(NSArray*)array;
-(NSArray*)audioFiles:(NSArray*)array;
-(BOOL)isFile:(File*)file format:(NSString*)format;

-(void)removeFiles:(NSArray*)files;

@end
