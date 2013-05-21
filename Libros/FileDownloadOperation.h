//
//  FileDownloader.h
//  Libros
//
//  Created by Sean Hess on 2/4/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

typedef void (^ProgressBlock)(NSInteger, NSInteger);

@interface FileDownloadOperation : NSOperation <NSURLConnectionDataDelegate>

@property (strong, nonatomic) File * file;
@property (strong, nonatomic) NSURL * localPath;

@property (strong, nonatomic) ProgressBlock progressCb;
@property (strong, nonatomic) NSMutableData * data;

@end
