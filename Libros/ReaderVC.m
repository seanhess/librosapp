//
//  ReaderVCViewController.m
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderVC.h"
#import "BookService.h"
#import "FileService.h"
#import "CTColumnView.h"
#import <CoreText/CoreText.h>

@interface ReaderVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSAttributedString * text;

@end

@implementation ReaderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.book.title;
    
    FileService * fs = [FileService shared];
    NSArray * files = [fs byBookId:self.book.bookId];
    self.scrollView.pagingEnabled = YES;
    
    NSString * bookPlainString = [fs readAsText:files[0]];
    NSAttributedString * bookAttributed = [[NSAttributedString alloc] initWithString:bookPlainString];
    [self setAttributedText:bookAttributed];
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGSize(self.view.bounds.size));
    [self buildFrames];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// READER
// We need a paged scroll view!

- (void)setAttributedText:(NSAttributedString *)text {
    
    // JUSTIFIED TEXT
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = @{
        (NSString*)kCTParagraphStyleAttributeName : (__bridge id)paragraphStyle
    };
    
    // FONT
    CTFontRef font = CTFontCreateWithName(CFSTR("Verdana"), 16, NULL);
    
    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [text length])];
    [stringCopy addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, stringCopy.length)];
    
    self.text = stringCopy;
}

- (void)buildFrames {
    CGFloat frameXOffset = 20;
    CGFloat frameYOffset = 20;
    CGFloat columnWidth = self.scrollView.bounds.size.width;
    CGFloat columnHeight = self.scrollView.bounds.size.height;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.text);
    
    int textPos = 0;
    int columnIndex = 0;
    
    while (textPos < [self.text length]) {
        CGPoint columnOffset = CGPointMake(columnIndex*columnWidth, 0);
        CGRect columnFrame = CGRectMake(columnOffset.x, columnOffset.y, columnWidth, columnHeight);
        CGRect insetFrame = CGRectInset(columnFrame, frameXOffset, frameYOffset);
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: insetFrame];
        [self.scrollView addSubview:content];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, content.bounds);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        content.ctFrame = (__bridge id)frame;
        
        textPos += CTFrameGetVisibleStringRange(frame).length;
        columnIndex++;
        
        CFRelease(frame);
        CFRelease(path);
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1);
    self.scrollView.contentSize = CGSizeMake(totalPages*columnWidth, columnHeight);
}


@end
