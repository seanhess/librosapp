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
#import "ReaderPageView.h"
#import "ReaderFrameCache.h"
#import <CoreText/CoreText.h>

#define FRAME_X_OFFSET 20
#define FRAME_Y_OFFSET 20

#define DRAG_GRAVITY 15

typedef struct {
    NSInteger chapter;
    NSInteger page;
} ReaderLocation;

ReaderLocation ReaderLocationMake(NSInteger chapter, NSInteger page) {
    ReaderLocation location;
    location.chapter = chapter;
    location.page = page;
    return location;
}

ReaderLocation ReaderLocationInvalid() {
    ReaderLocation location;
    location.chapter = -1;
    location.page = -1;
    return location;
}



@interface ReaderVC ()

@property (strong, nonatomic) ReaderPageView * leftPageView;
@property (strong, nonatomic) ReaderPageView * currentPageView;
@property (strong, nonatomic) ReaderPageView * rightPageView;

// the one currently being dragged on / shown
@property (strong, nonatomic) ReaderPageView * nextPageView;
@property (nonatomic) CGRect nextPageStartFrame;

@property (strong, nonatomic) id framesetter;
@property (nonatomic) ReaderLocation location;

@property (strong, nonatomic) ReaderFrameCache * frameCache;
@property (strong, nonatomic) NSArray * files;

@property (nonatomic) CGPoint startTouchPoint;
@property (nonatomic) BOOL dragging;

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
    self.frameCache = [ReaderFrameCache new];
    self.location = ReaderLocationMake(0, 0);
    [self initPages];
    // TOO EARLY TO DRAW! Widths are wrong
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGSize(self.view.bounds.size));
    
    self.leftPageView.frame = self.leftFrame;
    self.currentPageView.frame = self.mainFrame;
    self.rightPageView.frame = self.rightFrame;
    
    // load the current stuff!
    NSArray * frames = [self generateFramesForChapter:self.location.chapter];
    [self.frameCache setFrames:frames forChapter:self.location.chapter];
    [self.currentPageView setFrameFromCache:self.frameCache chapter:self.location.chapter page:self.location.page];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self buildFrames];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.frameCache emptyExceptChapter:self.location.chapter];
}

- (CGRect) leftFrame {
    CGRect frame = self.view.bounds;
    frame.origin.x = -frame.size.width;
    return frame;
}

- (CGRect) mainFrame {
    return self.view.bounds;
}

- (CGRect) rightFrame {
    CGRect frame = self.view.bounds;
    frame.origin.x = frame.size.width;
    return frame;
}

- (void)initPages {
    self.leftPageView = [[ReaderPageView alloc] initWithFrame:self.leftFrame];
    self.currentPageView = [[ReaderPageView alloc] initWithFrame:self.mainFrame];
    self.rightPageView = [[ReaderPageView alloc] initWithFrame:self.rightFrame];
    
    [self.view addSubview:self.leftPageView];
    [self.view addSubview:self.currentPageView];
    [self.view addSubview:self.rightPageView];
}


// READER
// cleans up the text, adds a font and justified alignment, etc
- (NSMutableAttributedString*)formatText:(NSAttributedString *)text {
    
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

-(NSAttributedString*)textForChapter:(NSInteger)chapter {
    NSString * bookPlainString = [[FileService shared] readAsText:self.files[chapter]];
    NSMutableAttributedString * chapterText = [self formatText:[[NSAttributedString alloc] initWithString:bookPlainString]];
    [chapterText insertAttributedString:[self chapterHeading:chapter] atIndex:0];
    return chapterText;
}

-(NSAttributedString*)chapterHeading:(NSInteger)chapter {
    File* file = self.files[chapter];
    CTFontRef font = CTFontCreateWithName(CFSTR("Verdana-Bold"), 24, NULL);
    NSString * headerWithNewline = [NSString stringWithFormat:@"%@\n\n", file.name];
    
    
    // Alignment
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    NSMutableAttributedString * heading = [[NSMutableAttributedString alloc] initWithString:headerWithNewline];
    NSRange fullRange = NSMakeRange(0, heading.length);
    [heading addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:fullRange];
    [heading addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:fullRange];
    return heading;
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

- (ReaderLocation)next:(ReaderLocation)location {
    if (location.page+1 < [self.frameCache pagesForChapter:location.chapter]) {
        location.page += 1;
        return location;
    }
    else {
        NSInteger nextChapter = location.chapter + 1;
        if (nextChapter >= self.files.count)
            return ReaderLocationInvalid();
        else {
            if (![self.frameCache hasFramesForChapter:nextChapter])
                [self.frameCache setFrames:[self generateFramesForChapter:nextChapter] forChapter:nextChapter];
            return ReaderLocationMake(location.chapter + 1, 0);
        }
    }
}

- (ReaderLocation)prev:(ReaderLocation)location {
    if (location.page > 0) {
        location.page -= 1;
        return location;
    }
    else {
        NSInteger previousChapter = location.chapter - 1;
        if (previousChapter < 0) return ReaderLocationInvalid();
        
        if (![self.frameCache hasFramesForChapter:previousChapter])
            [self.frameCache setFrames:[self generateFramesForChapter:previousChapter] forChapter:previousChapter];
        
        return ReaderLocationMake(previousChapter, [self.frameCache pagesForChapter:previousChapter]-1);
    }
}

- (BOOL)isValidLocation:(ReaderLocation)location {
    return location.chapter >= 0;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    self.startTouchPoint = [touch locationInView:self.view];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat dx = point.x - self.startTouchPoint.x;
    
    // we don't wnat to reset things
    if (!self.dragging && abs(dx) > DRAG_GRAVITY) {
        ReaderLocation nextLocation;
        if (dx < 0) {
            nextLocation = [self next:self.location];
            if (![self isValidLocation:nextLocation]) return;
            self.nextPageView = self.rightPageView;
            self.nextPageStartFrame = self.rightFrame;
        }
        
        else {
            nextLocation = [self prev:self.location];
            if (![self isValidLocation:nextLocation]) return;
            self.nextPageView = self.leftPageView;
            self.nextPageStartFrame = self.leftFrame;
        }
        
        NSLog(@"DRAGGING!");
        self.dragging = YES;
        [self.nextPageView setFrameFromCache:self.frameCache chapter:nextLocation.chapter page:nextLocation.page];
        
    }
    
    if (self.dragging) {
        // Main + One other one (right or left)
        // Save its state on it?
        // yeah, set the chapter and page ON the view
        
        // just render them all right now, no matters whats
//        self.nextPageView.backgroundColor = [UIColor redColor];
        CGRect nextFrame = self.nextPageView.frame;
        nextFrame.origin.x = self.nextPageStartFrame.origin.x + dx;
        self.nextPageView.frame = nextFrame;
        
        CGRect mainFrame = self.mainFrame;
        mainFrame.origin.x = mainFrame.origin.x + dx;
        self.currentPageView.frame = mainFrame;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (self.dragging) {
        self.dragging = NO;
        self.nextPageView = nil;
        
        // current page is almost left
        if (self.currentPageView.frame.origin.x > self.mainFrame.size.width/2) {
            [self animatePageTurn:^{ [self moveLeft]; }];
        }
        
        // center
        else if (self.currentPageView.frame.origin.x > -self.mainFrame.size.width/2) {
            [self animatePageTurn:^{ [self moveHome]; }];
        }
        
        // right
        else {
            [self animatePageTurn:^{ [self moveRight]; }];
        }
    }
    
    else {
        // check for taps
        
        if (point.x > 0.8*self.view.bounds.size.width) {
            ReaderLocation nextLocation = [self next:self.location];
            if (![self isValidLocation:nextLocation]) return;
            [self.rightPageView setFrameFromCache:self.frameCache chapter:nextLocation.chapter page:nextLocation.page];
            [self animatePageTurn:^{ [self moveRight]; }];
        }
        
        else if (point.x < 0.2*self.view.bounds.size.width) {
            ReaderLocation nextLocation = [self prev:self.location];
            if (![self isValidLocation:nextLocation]) return;
            [self.leftPageView setFrameFromCache:self.frameCache chapter:nextLocation.chapter page:nextLocation.page];
            [self animatePageTurn:^{ [self moveLeft]; }];
        }
    }
}

- (void)animatePageTurn:(void(^)(void))animations {
    [UIView animateWithDuration:0.2 animations:animations completion: ^(BOOL finished) {
         [self moveHome];
    }];
}

- (void)moveRight {
    self.rightPageView.frame = self.mainFrame;
    self.currentPageView.frame = self.leftFrame;
    self.location = [self next:self.location];
    
    ReaderPageView * rightPageView = self.rightPageView;
    self.rightPageView = self.currentPageView;
    self.currentPageView = rightPageView;
}

- (void)moveLeft {
    self.location = [self prev:self.location];
    self.leftPageView.frame = self.mainFrame;
    self.currentPageView.frame = self.rightFrame;
    
    ReaderPageView * leftPageView = self.leftPageView;
    self.leftPageView = self.currentPageView;
    self.currentPageView = leftPageView;
}

- (void)moveHome {
    self.currentPageView.frame = self.mainFrame;
    self.leftPageView.frame = self.leftFrame;
    self.rightPageView.frame = self.rightFrame;
}




/*

- (void)nextPage {
    
    if (![self setNextPage]) return;
    
    ReaderPageView * nextPageView = [self getAvailablePage];
    [nextPageView renderFrame:[self frameForPage:self.currentPage]];
    
    
    
    CGRect frame = self.view.bounds;
    frame.origin.x = frame.size.width;
    nextPageView.frame = frame;
    
    [UIView beginAnimations:@"nextPage" context:nil];

    frame.origin.x = 0;
    nextPageView.frame = frame;
    
    frame.origin.x = -frame.size.width;
    self.currentPageView.frame = frame;
    
    [UIView commitAnimations];
    
    [self doneAvailablePage:self.currentPageView];
    self.currentPageView = nextPageView;
}

- (void)prevPage {
    
    if (![self setPrevPage]) return;
    
    ReaderPageView * nextPageView = [self getAvailablePage];
    [nextPageView renderFrame:[self frameForPage:self.currentPage]];
    
    
    
    CGRect frame = self.view.bounds;
    frame.origin.x = -frame.size.width;
    nextPageView.frame = frame;
    
    [UIView beginAnimations:@"prevPage" context:nil];
    
    frame.origin.x = 0;
    nextPageView.frame = frame;
    
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

}

*/

@end
