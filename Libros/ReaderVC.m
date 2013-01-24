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
#import "ReaderPageView.h"
#import <CoreText/CoreText.h>

#define FRAME_X_OFFSET 20
#define FRAME_Y_OFFSET 20

@interface ReaderVC ()

@property (strong, nonatomic) NSMutableArray * availablePages;
@property (strong, nonatomic) ReaderPageView * currentPageView;

@property (strong, nonatomic) id framesetter;
@property (nonatomic) NSInteger currentChapter;
@property (nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSMutableArray * currentChapterFrames;

@property (strong, nonatomic) NSArray * files;

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
    
    self.files = [[FileService shared] byBookId:self.book.bookId];
    
    // INITIALIZE
    [self createAvailablePages];
    self.currentChapterFrames = [NSMutableArray array];
    self.currentPage = 0;
    self.currentChapter = 0;
    // TOO EARLY TO DRAW! Widths are wrong
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGSize(self.view.bounds.size));
    [self drawPage:self.currentPageView chapter:self.currentChapter page:self.currentPage];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self buildFrames];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createAvailablePages {
    self.availablePages = [NSMutableArray array];
    [self createAvailablePage];
    [self createAvailablePage];
    self.currentPageView = [self getAvailablePage];
}

- (void)createAvailablePage {
    ReaderPageView * pageView = [ReaderPageView new];
    pageView.frameXOffset = 20;
    pageView.frameYOffset = 20;
    [self.availablePages addObject:pageView];
    [self.view addSubview:pageView];
}

- (ReaderPageView*)getAvailablePage {
    ReaderPageView * pageView = [self.availablePages lastObject];
    [self.availablePages removeLastObject];
    return pageView;
}

- (void)doneAvailablePage:(ReaderPageView*)pageView {
    [self.availablePages addObject:pageView];
}

// READER
// cleans up the text, adds a font and justified alignment, etc
- (NSAttributedString*)formatText:(NSAttributedString *)text {
    
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
    
    return stringCopy;
}

// returns a CTFrame for that chapter, ready to go
// should we just cache all the frames? I'm creating them anyway
// no, just cache the locations
// but then I'll be creating the frames TWICE. that's dumb.
// alright, discard the whole cache then, each time you load a chapter, if you need to save memory
-(id)frameForPage:(NSInteger)page {
    return self.currentChapterFrames[page];
}

-(NSInteger)currentChapterPages {
    return self.currentChapterFrames.count;
}

// sets the current chapter, wipes the frame cache, and creates new frames!
-(void)switchToChapter:(NSInteger)chapter {
    self.currentChapter = chapter;
    self.currentChapterFrames = [self generateFramesForChapter:chapter];
}

-(NSAttributedString*)textForChapter:(NSInteger)chapter {
    NSString * bookPlainString = [[FileService shared] readAsText:self.files[chapter]];
    NSAttributedString * bookAttributed = [[NSAttributedString alloc] initWithString:bookPlainString];
    return [self formatText:bookAttributed];
}

-(NSMutableArray*)generateFramesForChapter:(NSInteger)chapter {
    NSInteger location = 0;
    
    NSAttributedString * text = [self textForChapter:chapter];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    self.framesetter = (__bridge id)framesetter;
    CFRelease(framesetter);
    
    NSMutableArray * frames = [NSMutableArray array];
    
    while(location < text.length) {
        NSLog(@"GENERATING for chapter=%i location=%i", chapter, location);
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect insetFrame = CGRectInset(self.view.bounds, FRAME_X_OFFSET, FRAME_Y_OFFSET);
        CGPathAddRect(path, NULL, insetFrame);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(location, 0), path, NULL);
        [frames addObject:(__bridge id)frame];
        location += CTFrameGetVisibleStringRange(frame).length;
        CFRelease(frame);
        CFRelease(path);
    }
    
    return frames;
}

- (void)drawPage:(ReaderPageView*)pageView chapter:(NSInteger)chapter page:(NSInteger)page {
    pageView.frame = self.view.bounds;
    [self switchToChapter:chapter];
    self.currentPage = page;
    [pageView renderFrame:[self frameForPage:page]];
}

- (void)nextPage {
    ReaderPageView * nextPageView = [self getAvailablePage];
    CGRect frame = self.view.bounds;
    frame.origin.x = frame.size.width;
    nextPageView.frame = frame;
    nextPageView.hidden = NO;

    [UIView beginAnimations:@"nextPage" context:nil];

    frame.origin.x = 0;
    nextPageView.frame = frame;
    
    // advance the page
    self.currentPage += 1;
    if (self.currentPage >= [self currentChapterPages]) {
        self.currentPage = 0;
        self.currentChapter += 1;
        self.currentChapterFrames = [self generateFramesForChapter:self.currentChapter];
    }
    
    // render
    [nextPageView renderFrame:[self frameForPage:self.currentPage]];
    
    frame.origin.x = -frame.size.width;
    self.currentPageView.frame = frame;
    
    [UIView commitAnimations];
    
    [self doneAvailablePage:self.currentPageView];
    self.currentPageView = nextPageView;
}

- (void)prevPage {
    ReaderPageView * nextPageView = [self getAvailablePage];
    CGRect frame = self.view.bounds;
    frame.origin.x = -frame.size.width;
    nextPageView.frame = frame;
    nextPageView.hidden = NO;
    
    [UIView beginAnimations:@"prevPage" context:nil];
    
    frame.origin.x = 0;
    nextPageView.frame = frame;
    
    // rewind the page
    self.currentPage -= 1;
    if (self.currentPage < 0) {
        self.currentChapter -= 1;
        self.currentChapterFrames = [self generateFramesForChapter:self.currentChapter];
        self.currentPage = [self currentChapterPages] - 1;
    }
    
    [nextPageView renderFrame:[self frameForPage:self.currentPage]];
    
    frame.origin.x = frame.size.width;
    self.currentPageView.frame = frame;
    
    [UIView commitAnimations];
    
    [self doneAvailablePage:self.currentPageView];
    self.currentPageView = nextPageView;
}

// A tap gesture on the right side = next page!
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (point.x > 0.8*self.view.bounds.size.width) {
        [self nextPage];
    }
    
    else if (point.x < 0.2*self.view.bounds.size.width) {
        [self prevPage];
    }
}

@end
