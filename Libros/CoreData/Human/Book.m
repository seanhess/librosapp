#import "Book.h"
#import "FileService.h"
#import "NSArray+Functional.h"
#import "BookService.h"

@interface Book ()
@property (nonatomic, strong) NSArray * orderedFiles;
@end

@implementation Book
@synthesize orderedFiles;

// Custom logic goes here.
// only loads them once! will cache
-(NSArray *)allFiles {
    if (!self.orderedFiles) {
        self.orderedFiles = [[FileService shared] byBookId:self.bookId];
    }
    
    return self.orderedFiles;
}

//-(NSString*)priceString {
//    return [[BookService shared] priceString:self];
//}

-(NSString*)productId {
    return [self.bookId stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

-(BOOL)isDownloading {
    return (0.0 < self.downloadedValue) && (self.downloadedValue < 1.0);
}

-(BOOL)isDownloadComplete {
    return (self.downloadedValue == 1.0);
}

@end
