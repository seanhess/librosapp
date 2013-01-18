//
//  FileService.h
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface FileService : NSObject

+(FileService*)shared;

-(void)loadFilesForBook:(NSString*)bookId cb:(void(^)(void))cb;
-(void)downloadFiles:(NSArray*)files cb:(void(^)(void))cb;

-(NSArray*)byBookId:(NSString*)bookId;

-(NSURL*)url:(File*)file;
-(NSString*)localPath:(File*)file;

@end
