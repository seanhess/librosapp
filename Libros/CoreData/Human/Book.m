#import "Book.h"
#import "FileService.h"
#import "NSArray+Functional.h"

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

-(NSString*)priceString {
    NSInteger dollars = floorf(self.priceValue / 100);
    NSInteger pennies = self.priceValue % 100;
    return [NSString stringWithFormat:@"%i.%02i", dollars, pennies];
}

-(NSString*)productId {
    return [self.bookId stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

@end
