#import "Book.h"
#import "FileService.h"
#import "NSArray+Functional.h"

@implementation Book

// Custom logic goes here.
// only loads them once! will cache
-(NSArray *)allFiles {
    if (![self.files count]) {
        NSArray * files = [[FileService shared] byBookId:self.bookId];
        [self addFiles:[NSSet setWithArray:files]];
    }
    
    return [self.files allObjects];
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
