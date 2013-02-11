#import "_Book.h"


typedef enum {
    BookFilterEverything = 0,
    BookFilterHasAudio,
    BookFilterHasText
} BookFilter;

typedef enum {
    BookFormatText = 1,
    BookFormatAudio
} BookFormat;

@interface Book : _Book {}
// Custom logic goes here.

-(NSArray*)allFiles;
-(NSString*)priceString;

@end
