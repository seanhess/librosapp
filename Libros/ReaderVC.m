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



@interface ReaderVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    
//    UICollectionViewLayout * layout = [[UICollectionViewLayout alloc] init];
//    self.collectionView
    [self.collectionView registerClass:[ReaderPageView class] forCellWithReuseIdentifier:@"BookPage"];
    
    FileService * fs = [FileService shared];
    
    self.title = self.book.title;
    NSArray * allFiles = [fs byBookId:self.book.bookId];
    self.files = [fs filterFiles:allFiles byFormat:FileFormatText];
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    self.formatter.files = self.files;
    
    self.framesetter = [ReaderFramesetter new];
    self.framesetter.formatter = self.formatter;
    self.location = ReaderLocationMake(0, 0);
    
    // TOO EARLY TO DRAW! View Size is wrong
    NSLog(@"VIEW DID LOAD %@", NSStringFromCGRect(self.view.bounds));
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGRect(self.view.bounds));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.framesetter emptyExceptChapter:self.location.chapter];
}

- (IBAction)didTapLibrary:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapFont:(id)sender {
    
}

- (IBAction)didTapText:(UITapGestureRecognizer*)tap {
    CGPoint location = [tap locationInView:tap];
    [self showControls];
}

- (IBAction)didTapControls:(id)sender {
    [self hideControls];
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

#pragma mark UICollectionViewDelegate

// wait, each section could be each chapter
// that's a nice easy way to do it!
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.files.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

// sizes correct at this point
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"CELL %@", NSStringFromCGRect(self.view.bounds));
    static NSString * cellId = @"BookPage";
    UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    self.framesetter.bounds = cell.bounds;
    
    [self.framesetter ensurePagesForChapter:indexPath.section];
    [(ReaderPageView*)cell setFrameFromCache:self.framesetter chapter:indexPath.section page:indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.view.bounds.size;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
