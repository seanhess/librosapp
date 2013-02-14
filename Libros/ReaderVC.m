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

@interface ReaderVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (nonatomic) NSInteger currentChapter;
@property (nonatomic) NSInteger currentPage;

@property (strong, nonatomic) ReaderFramesetter * framesetter;
@property (strong, nonatomic) ReaderFormatter * formatter;
@property (strong, nonatomic) NSArray * files;
@property (nonatomic) NSInteger numChapters;

@property (nonatomic) BOOL scrolling;

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
    self.numChapters = self.files.count;
    self.wantsFullScreenLayout = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    
    self.framesetter = [ReaderFramesetter new];
    self.framesetter.formatter = self.formatter; // change to use a delegate so you don't have to pass these in
    self.framesetter.files = self.files;
    self.currentChapter = 0;
    self.currentPage = 0;
    
    // TOO EARLY TO DRAW! View Size is wrong
    NSLog(@"VIEW DID LOAD %@", NSStringFromCGRect(self.view.bounds));
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGRect(self.view.bounds));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"WILL ROTATE %@", NSStringFromCGRect(self.collectionView.bounds));
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"DID ROTATE %@", NSStringFromCGRect(self.collectionView.bounds));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.framesetter emptyExceptChapter:self.currentChapter];
    
    // Do NOT reload the table at this time?
    // It will remember all your previously created cells
}

- (IBAction)didTapLibrary:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)didTapFont:(id)sender {
    
}

- (IBAction)didTapControls:(id)sender {
    [self hideControls];
}

- (IBAction)didTapText:(UITapGestureRecognizer*)tap {
    
    NSLog(@"TESTING %i %i", self.collectionView.dragging, self.collectionView.decelerating);
    
    if (!self.scrollViewIsAtRest) return;
    
    CGPoint point = [tap locationInView:self.view];
    
    NSIndexPath * newLocation = nil;
    
    if (point.x > 0.8*self.view.bounds.size.width) {
        newLocation = [self next:self.currentChapter page:self.currentPage];
    }
    
    else if (point.x < 0.2*self.view.bounds.size.width) {
        newLocation = [self prev:self.currentChapter page:self.currentPage];
    }
    
    else {
        [self showControls];
    }
    
    if (newLocation) {
        [self.collectionView scrollToItemAtIndexPath:newLocation atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (BOOL)scrollViewIsAtRest {
    CGPoint offset = self.collectionView.contentOffset;
    return (((int)offset.x % (int)self.view.frame.size.width) == 0);
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {}

// only call this when at rest
- (void)updateCurrentPage {
    // which page is in the MIDDLE of the window?
    NSIndexPath * cellIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.view.frame.size.width/2, 0)];
    NSInteger chapter = cellIndexPath.section;
    NSInteger page = cellIndexPath.item;
    self.currentChapter = chapter;
    self.currentPage = page;
        
    if ([self isChapterNext:chapter page:page] && ![self.framesetter hasPagesForChapter:chapter+1]) {
        [self.framesetter ensurePagesForChapter:chapter+1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
    else if ([self isChapterPrev:chapter page:page] && ![self.framesetter hasPagesForChapter:chapter-1]) {
        [self.framesetter ensurePagesForChapter:chapter-1];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}


// you ALWAYS have to call this guy
// also updates the currents
- (void)moveToChapter:(NSInteger)chapter page:(NSInteger)page animated:(BOOL)animated {
    
}

- (void)scrollToChapter:(NSInteger)chapter page:(NSInteger)page {
    NSInteger startIndex = [self cellOffsetForChapter:self.currentChapter page:self.currentPage];
    NSInteger endIndex = [self cellOffsetForChapter:chapter page:page];
    CGPoint offset = self.collectionView.contentOffset;
    offset.x = startIndex * self.view.bounds.size.width;
    [self.collectionView setContentOffset:offset animated:NO];
    offset.x = endIndex * self.view.bounds.size.width;
    [self.collectionView setContentOffset:offset animated:YES];
}

- (NSInteger)cellOffsetForChapter:(NSInteger)chapter page:(NSInteger)page {
    NSInteger pages = 0;
    
    for (int c = 0; c < chapter; c++) {
        pages += [self cellsDisplayedInChapter:chapter];
    }
    
    pages += page;
    return pages;
}

- (NSInteger)cellsDisplayedInChapter:(NSInteger)chapter {
    if ([self.framesetter hasPagesForChapter:chapter]) {
        return [self.framesetter pagesForChapter:chapter];
    }
    else return 1;
}

- (void)ensurePagesForChapter:(NSInteger)chapter {
    self.framesetter.bounds = self.view.bounds;
    [self.framesetter ensurePagesForChapter:chapter];
}

- (NSIndexPath*)next:(NSInteger)chapter page:(NSInteger)page {
    if (page+1 < [self.framesetter pagesForChapter:chapter]) {
        return [NSIndexPath indexPathForItem:page+1 inSection:chapter];
    }
    else {
        NSInteger nextChapter = chapter + 1;
        if (nextChapter >= self.files.count)
            return nil;
        else {
            [self ensurePagesForChapter:nextChapter];
            return [NSIndexPath indexPathForItem:0 inSection:nextChapter];
        }
    }
}

// you have to ensure the previous chapter, because
- (NSIndexPath*)prev:(NSInteger)chapter page:(NSInteger)page {
    if (page > 0) {
        return [NSIndexPath indexPathForItem:page-1 inSection:chapter];
    }
    else {
        NSInteger previousChapter = chapter - 1;
        if (previousChapter < 0) return nil;
        [self ensurePagesForChapter:previousChapter];
        return [NSIndexPath indexPathForItem:([self.framesetter pagesForChapter:previousChapter]-1) inSection:previousChapter];
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

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.numChapters;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // generate the pages for the very first one!
    if (self.currentChapter == section) {
        self.framesetter.bounds = self.view.bounds;
        [self.framesetter ensurePagesForChapter:section];
    }
    
    return [self cellsDisplayedInChapter:section];
}

-(BOOL)isChapterNext:(NSInteger)chapter page:(NSInteger)page {
    return (page == [self.framesetter pagesForChapter:chapter]-1 && chapter < self.numChapters-1);
}

-(BOOL)isChapterPrev:(NSInteger)chapter page:(NSInteger)page {
    return (page == 0 && chapter > 0);
}

// sizes correct at this point
// this is the current page and chapter, easy to calculate!

// if it is the LAST page in the chapter, then generate the pages for the next one

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"BookPage";
    NSInteger chapter = indexPath.section;
    NSInteger page = indexPath.item;
//    NSLog(@"CELL chapter=%i page=%i", chapter, page);
    UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    self.framesetter.bounds = cell.bounds;
    
// I DO need some way to update them if you scroll, but not this
//    self.currentChapter = chapter;
//    self.currentPage = page; // is this true? not nececssarily

    
//    NSLog(@" - set frame %i %i", indexPath.section, indexPath.item);
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
