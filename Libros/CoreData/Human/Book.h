#import "_Book.h"


typedef enum {
    BookFilterEverything = 0,
    BookFilterHasText,
    BookFilterHasAudio
} BookFilter;

typedef enum {
    BookFormatText = 1,
    BookFormatAudio
} BookFormat;


@interface Book : _Book {}
// Custom logic goes here.

-(NSArray*)allFiles;

//-(NSString*)priceString;
-(NSString*)productId;      // In-App Purchase Product Id matching iTunes Connect

-(BOOL)isDownloading;
-(BOOL)isDownloadComplete;

@end
