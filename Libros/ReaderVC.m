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
#import "ReaderFramesetter.h"
#import "ReaderFormatter.h"
#import <CoreText/CoreText.h>

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

@property (nonatomic) ReaderLocation location;

@property (strong, nonatomic) ReaderFramesetter * framesetter;
@property (strong, nonatomic) ReaderFormatter * formatter;
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    self.formatter.files = self.files;
    self.framesetter = [ReaderFramesetter new];
    self.framesetter.formatter = self.formatter;
    self.location = ReaderLocationMake(0, 0);
    [self initPages];
    // TOO EARLY TO DRAW! Widths are wrong
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGSize(self.view.bounds.size));
    
    self.framesetter.bounds = self.view.bounds;
    
    self.leftPageView.frame = self.leftFrame;
    self.currentPageView.frame = self.mainFrame;
    self.rightPageView.frame = self.rightFrame;
    
    // load the current stuff!
    [self.framesetter ensureFramesForChapter:self.location.chapter];
    [self.currentPageView setFrameFromCache:self.framesetter chapter:self.location.chapter page:self.location.page];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self buildFrames];
    self.framesetter.bounds = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.framesetter emptyExceptChapter:self.location.chapter];
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




- (ReaderLocation)next:(ReaderLocation)location {
    if (location.page+1 < [self.framesetter pagesForChapter:location.chapter]) {
        location.page += 1;
        return location;
    }
    else {
        NSInteger nextChapter = location.chapter + 1;
        if (nextChapter >= self.files.count)
            return ReaderLocationInvalid();
        else {
            [self.framesetter ensureFramesForChapter:nextChapter];
            return ReaderLocationMake(nextChapter, 0);
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
        [self.framesetter ensureFramesForChapter:previousChapter];
        return ReaderLocationMake(previousChapter, [self.framesetter pagesForChapter:previousChapter]-1);
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
        
        self.dragging = YES;
        [self.nextPageView setFrameFromCache:self.framesetter chapter:nextLocation.chapter page:nextLocation.page];
        
    }
    
    if (self.dragging) {
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
            [self.rightPageView setFrameFromCache:self.framesetter chapter:nextLocation.chapter page:nextLocation.page];
            [self animatePageTurn:^{ [self moveRight]; }];
        }
        
        else if (point.x < 0.2*self.view.bounds.size.width) {
            ReaderLocation nextLocation = [self prev:self.location];
            if (![self isValidLocation:nextLocation]) return;
            [self.leftPageView setFrameFromCache:self.framesetter chapter:nextLocation.chapter page:nextLocation.page];
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


@end
