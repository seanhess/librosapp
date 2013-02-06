#import "_Book.h"


typedef enum {
    BookFilterEverything = 0,
    BookFilterHasAudio,
    BookFilterHasText
} BookFilter;

@interface Book : _Book {}
// Custom logic goes here.

-(NSArray*)allFiles;
-(NSString*)priceString;

@end
