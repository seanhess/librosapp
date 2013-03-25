//
//  FileDownloader.m
//  Libros
//
//  Created by Sean Hess on 2/4/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "FileDownloadOperation.h"
#import "ReaderFormatter.h"
#import "LBParsedString.h"
#import "FileService.h"

@interface FileDownloadOperation ()
@property (strong, nonatomic) NSURLConnection * connection;
@property (nonatomic) NSInteger contentLength;
@property (nonatomic) BOOL finished;
@end

@implementation FileDownloadOperation

// Concurrent means ASYNC in this case!
// NOT parallel, which happens by default

-(BOOL)isConcurrent {
    return YES;
}

-(BOOL)isExecuting {
    return !self.finished;
}

-(BOOL)isFinished {
    return self.finished;
}

-(void)finish {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"DOWNLOADED %@", self.file.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(void)start {
    // NSLog(@"DOWNLOADING %@", self.file.url);
    // why did I put this in the main queue? I think it has something to do with the operation
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finished = NO;
        NSURL * url = [NSURL URLWithString:self.file.url];
        NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        self.data = [[NSMutableData alloc] initWithLength:0];
    });
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.contentLength = [response expectedContentLength];
    [self.data setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
    self.progressCb(self.data.length, self.contentLength);
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERROR (%@) %@", self.file.url, error);
    [self finish];
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // 1 // convert to NSAttributedString, then save the data
    
    if ([FileService.shared isFile:self.file format:FileFormatText]) {
        ReaderFormatter * formatter = [ReaderFormatter new];
        NSString * string = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        LBParsedString * text = [formatter parsedStringForMarkup:string];
        [NSKeyedArchiver archiveRootObject:text toFile:self.localPath];
    }
    
    else {
        [self.data writeToFile:self.localPath options:NSDataWritingAtomic error:nil];
    }
    
    [self finish];
}

@end
