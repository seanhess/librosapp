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

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (weak, nonatomic) IBOutlet ReaderPageView *leftPageView;
@property (weak, nonatomic) IBOutlet ReaderPageView *currentPageView;
@property (weak, nonatomic) IBOutlet ReaderPageView *rightPageView;

// the one currently being dragged on / shown
@property (weak, nonatomic) ReaderPageView * nextPageView;
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
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    self.formatter.files = self.files;
    self.framesetter = [ReaderFramesetter new];
    self.framesetter.formatter = self.formatter;
    self.location = ReaderLocationMake(0, 0);
    
    // TOO EARLY TO DRAW! Widths are wrong
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGSize(self.view.bounds.size));
    
    self.framesetter.bounds = self.view.bounds;
    
    self.leftPageView.frame = self.leftFrame;
    self.currentPageView.frame = self.mainFrame;
    self.rightPageView.frame = self.rightFrame;
    
    // load the current stuff!
    [self.framesetter ensurePagesForChapter:self.location.chapter];
    [self.currentPageView setFrameFromCache:self.framesetter chapter:self.location.chapter page:self.location.page];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // BOUNDS ARE WRONG HERE
    [self.leftPageView clear];
    [self.rightPageView clear];
    [self.currentPageView clear];
    
    // But we can estimate them!
    CGRect bounds = CGRectMake(0, 0, 0, 0);
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        bounds.size.width = MAX(width, height);
        bounds.size.height = MIN(width, height);
    }
    else {
        bounds.size.width = MIN(width, height);
        bounds.size.height = MAX(width, height);
    }
    
    self.framesetter.bounds = bounds;
    
    CGFloat percentProgress = [self.framesetter percentThroughChapter:self.location.chapter page:self.location.page];
    NSLog(@"PERCENT %f page=%i pages=%i", percentProgress, self.location.page, [self.framesetter pagesForChapter:self.location.chapter]);
    [self.framesetter empty];
    [self.framesetter ensurePagesForChapter:self.location.chapter];
    self.location = ReaderLocationMake(self.location.chapter, [self.framesetter pageForChapter:self.location.chapter percent:percentProgress]);
    
    [self.currentPageView setFrameFromCache:self.framesetter chapter:self.location.chapter page:self.location.page];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
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

- (IBAction)didTapLibrary:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapFont:(id)sender {
    
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
            [self.framesetter ensurePagesForChapter:nextChapter];
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
        [self.framesetter ensurePagesForChapter:previousChapter];
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
        [self hideControls];
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
            [self moveHome];
            [self animatePageTurn:^{ [self moveRight]; }];
            [self hideControls];
        }
        
        else if (point.x < 0.2*self.view.bounds.size.width) {
            ReaderLocation nextLocation = [self prev:self.location];
            if (![self isValidLocation:nextLocation]) return;
            [self.leftPageView setFrameFromCache:self.framesetter chapter:nextLocation.chapter page:nextLocation.page];
            [self moveHome];
            [self animatePageTurn:^{ [self moveLeft]; }];
            [self hideControls];
        }
        
        else {
            [self toggleControls];
        }
    }
}

- (void)toggleControls {
    if (self.navigationController.navigationBarHidden) {
        [self showControls];
    }
    else {
        [self hideControls];
    }
}

- (void)hideControls {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView beginAnimations:@"controls" context:nil];
    self.controlsView.alpha = 0.0;
    [UIView commitAnimations];
}
- (void)showControls {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView beginAnimations:@"controls" context:nil];
    self.controlsView.alpha = 1.0;
    [UIView commitAnimations];
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
