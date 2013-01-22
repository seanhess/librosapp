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
@property (strong, nonatomic) NSMutableArray * frames;
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
    
    // Assume book has been set by now
    self.title = self.book.title;
    
    // Load chapter one!
    FileService * fs = [FileService shared];
    NSArray * files = [fs byBookId:self.book.bookId];
//    NSLog(@"bookId=%@ files=%@", self.book.bookId, files);
//    self.textView.text = [fs readAsText:files[0]];
    
    // INITIALIZE SCROLL VIEW
    self.scrollView.pagingEnabled = YES;
    
    NSString * bookPlainString = [fs readAsText:files[0]];
    NSAttributedString * bookAttributed = [[NSAttributedString alloc] initWithString:bookPlainString];
    [self setAttributedText:bookAttributed];
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
    CGFloat frameXOffset = 0; //1
    CGFloat frameYOffset = 0;
    self.frames = [NSMutableArray array];
    
    // Create a path and a frame for the view's bounds
    // Just like before, but we inset it a bit
    CGMutablePathRef path = CGPathCreateMutable(); //2
    NSLog(@"TESTING %@ %@ %@", NSStringFromCGSize(self.scrollView.bounds.size), NSStringFromCGSize(self.view.bounds.size), NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
    CGRect textFrame = CGRectInset(self.scrollView.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.text);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [self.text length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*frameXOffset + columnIndex*(textFrame.size.width), 0 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width, textFrame.size.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view. They need full run of the parent view, apparently
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
		//set the column view contents and add it as subview
        [content setCtFrame:(__bridge id)frame];  //6
        [self.frames addObject:(__bridge id)frame];
        [self.scrollView addSubview:content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1); //7
    self.scrollView.contentSize = CGSizeMake(totalPages*self.scrollView.bounds.size.width, textFrame.size.height);
}


@end
