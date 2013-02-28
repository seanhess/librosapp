//
//  ReaderVCViewController.m
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

/*
[ ] Bug: looks funny during orientation changes
 
ALL POSSIBLE SCENARIOS - THE CHECKLIST
 [x] tap
 [x] swipe
 [x] drag
 [x] jump to chapter
 [x] interface orientation
 [x] memory warning
 [x] start at chapter / page (later)
 
 [x] swipe or drag, then tap
 [x] tap through to chapter 2. Does it load?
 [x] jump to chapter, swipe backwards
 [x] jump to chapter, swipe forwards to next chapter
 [x] interface change back and forth on page 1
 [x] interface change back and forth on page 2 (should preserve word when back to same orientation)
 [x] interface change full circle on page 1
 
 [x] swipe, interface change, tap, swipe, interface change, etc. Make sure it still works
 [x] jump to chapter 2, multiple interface changes, swipe back and forth
 
 [x] very last page in book, multiple interface orientation changes
 [x] jump to chapter 2, memory warning, swipe back
 [x] jump to chapter 2, move 1 page forward, memory warning, swipe back
 
 [ ] start at chapter 2, page 1, swipe back
*/


#import "ReaderVC.h"
#import "BookService.h"
#import "FileService.h"
#import "ReaderPageView.h"
#import "ReaderFramesetter.h"
#import "ReaderFormatter.h"
#import <CoreText/CoreText.h>
#import "ReaderTableOfContentsVC.h"

#define DRAG_GRAVITY 15

@interface ReaderVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ReaderFramesetterDelegate, ReaderTableOfContentsDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSInteger currentChapter;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat currentPercent;

@property (strong, nonatomic) ReaderFramesetter * framesetter;
@property (strong, nonatomic) ReaderFormatter * formatter;
@property (strong, nonatomic) NSArray * files;
@property (nonatomic) NSInteger numChapters;

@property (nonatomic) BOOL scrolling;

@property (weak, nonatomic) IBOutlet UIView *bottomControlsView;
@property (weak, nonatomic) IBOutlet UIView *topControlsView;
@property (weak, nonatomic) IBOutlet UIButton *fontButton;

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
    
    [self.collectionView registerClass:[ReaderPageView class] forCellWithReuseIdentifier:@"BookPage"];
    
    FileService * fs = [FileService shared];
    
    self.title = self.book.title;
    NSArray * allFiles = [fs byBookId:self.book.bookId];
    self.files = [fs filterFiles:allFiles byFormat:FileFormatText];
    self.numChapters = self.files.count;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self updateControlsFromBook];
    
    [self hideControlsInABit];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    
    // TOO EARLY TO DRAW! View Size is wrong
    // you can call reloadData early and it doesn't fire twice
//    NSLog(@"VIEW DID LOAD %@", NSStringFromCGRect(self.view.bounds));
}

- (void)viewWillAppear:(BOOL)animated {
    // OK TO DRAW - has correct size (IF you set navigation bar hidden to the same thing here as in viewDidLoad
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
//    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGRect(self.view.bounds));
    self.currentPage = 0;
    self.currentChapter = 0;
    
    [self newFramesetterWithSize:self.collectionView.bounds.size];

    [self ensurePagesForChapter:self.currentChapter];
    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGRect(self.view.bounds));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat currentPercent = [self.framesetter percentThroughChapter:self.currentChapter page:self.currentPage];
    NSLog(@"WILL ROTATE %i %i %f", self.currentChapter, self.currentPage, currentPercent);
    NSInteger currentChapter = self.currentChapter;
    
    CGSize newSize;
    CGSize oldSize = self.collectionView.frame.size;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        newSize.width = MAX(oldSize.width, oldSize.height);
        newSize.height = MIN(oldSize.width, oldSize.height);
    }
    else {
        newSize.width = MIN(oldSize.width, oldSize.height);
        newSize.height = MAX(oldSize.width, oldSize.height);
    }
    
    // creates a new framesetter, does NOT currently load the table or chapter
    [self newFramesetterWithSize:newSize];
    
    self.currentPercent = currentPercent;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    [UIView beginAnimations:@"fade" context:nil];
    self.collectionView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self ensurePagesForChapter:currentChapter];

    self.currentChapter = currentChapter;
    self.currentPage = [self.framesetter pageForChapter:currentChapter percent:currentPercent];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    NSLog(@"DID ROTATE %@", NSStringFromCGRect(self.collectionView.bounds));
    NSLog(@"DID ROTATE, moving to %i %i", self.currentChapter, self.currentPage);
    
    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
    
    [UIView beginAnimations:@"fade" context:nil];
    self.collectionView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.framesetter emptyExceptChapter:self.currentChapter];
    
    // not sure if these are actually necessary
    [self ensurePagesForChapter:self.currentChapter];
    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
}

- (void)newFramesetterWithSize:(CGSize)size {
    self.framesetter = [[ReaderFramesetter alloc] initWithSize:size];
    self.framesetter.delegate = self;
}

- (void)updateControlsFromBook {
    self.bottomControlsView.hidden = (self.book.audioFilesValue ==  0);
    self.fontButton.hidden = (self.book.textFilesValue == 0);
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapToC:(id)sender {
    NSLog(@"TOC");
    ReaderTableOfContentsVC * toc = [ReaderTableOfContentsVC new];
    toc.files = self.files;
    toc.delegate = self;
    [self.navigationController presentViewController:toc animated:YES completion:nil];
}

-(void)didCloseToc {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectChapter:(NSInteger)chapter {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.currentChapter = chapter;
    self.currentPage = 0;
    [self ensurePagesForChapter:chapter];
    [self moveToChapter:chapter page:0 animated:NO];
    [self hideControlsInABit];
}

- (IBAction)didTapLibrary:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)didTapFont:(id)sender {
    
}

- (IBAction)didTapText:(UITapGestureRecognizer*)tap {
    
    if (self.isControlsShown) {
        [self hideControls];
        return;
    }
    
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
        [self moveToChapter:newLocation.section page:newLocation.item animated:YES];
    }
}

- (void)moveToChapter:(NSInteger)chapter page:(NSInteger)page animated:(BOOL)animated {
    NSLog(@"MOVE TO %i %i", chapter, page);
    
    // This doesn't always left-align the cells, calculate your own, below
    // [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:chapter] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    CGFloat cellWidth = self.collectionView.frame.size.width;
    NSInteger pageOffset = [self cellOffsetForChapter:chapter page:page];
    CGFloat totalOffsetX = cellWidth * pageOffset;
    [self.collectionView setContentOffset:CGPointMake(totalOffsetX, 0) animated:animated];
    
    // Update the variables as well
    self.currentChapter = chapter;
    self.currentPage = page;
}

- (NSInteger)cellOffsetForChapter:(NSInteger)chapter page:(NSInteger)page {
    NSInteger pages = 0;
    
    for (int c = 0; c < chapter; c++) {
        pages += [self cellsDisplayedInChapter:c];
    }
    
    pages += page;
    return pages;
}

- (BOOL)scrollViewIsAtRest {
    CGPoint offset = self.collectionView.contentOffset;
    return (((int)offset.x % (int)self.view.frame.size.width) == 0);
}


// We need to figure out what the current page is after dragging or swiping
// based on which view is most visible
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isControlsShown)
        [self hideControls];
}

// NOT SAFE to calculate current page when changing interface orientations
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {}

// you MUST know the size at this point
// do not call too early!
- (void)initReaderWithSize:(CGSize)size chapter:(NSInteger)chapter {
    NSLog(@"INIT READER chapter=%i", chapter);
    
    // TODO - add support for initializing with chapter
    // but be careful, interface change calls this too!
//    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
}

- (NSAttributedString*)textForChapter:(NSInteger)chapter {
    return [self.formatter textForFile:self.files[chapter]];
}

- (void)updateCurrentPage {
    // only call this when at rest, or it gets confused
    // which page is in the MIDDLE of the window?
    NSIndexPath * cellIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.view.frame.size.width/2, 0)];
    NSInteger chapter = cellIndexPath.section;
    NSInteger page = cellIndexPath.item;
    self.currentChapter = chapter;
    self.currentPage = page;
}


- (NSInteger)cellsDisplayedInChapter:(NSInteger)chapter {
    // Each chapter has 1 page to start
    // then when they are loaded they return everything
    if ([self.framesetter hasPagesForChapter:chapter]) {
        return [self.framesetter pagesForChapter:chapter];
    }
    else return 1;
}


// these have to ensure the next chapter (well, at least prev), because otherwise
// it wouldn't know how many pages are in the previous chapter, and wouldn't know
// which one to set it to

// TODO Unless I switched it to use -1 for the page? that would be kind of cool
// then when it initializes it can know about those after its loaded

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

- (BOOL)isControlsShown {
    return (self.bottomControlsView.alpha > 0);
}

- (void)hideControlsInABit {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}

- (void)hideControls {
    [UIView beginAnimations:@"controls" context:nil];
    self.bottomControlsView.alpha = 0.0;
    self.topControlsView.alpha = 0.0;
    [UIView commitAnimations];
}
- (void)showControls {
    [UIView beginAnimations:@"controls" context:nil];
    self.bottomControlsView.alpha = 1.0;
    self.topControlsView.alpha = 1.0;
    [UIView commitAnimations];
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.numChapters;
}

// this gets called DURING first initialization
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self cellsDisplayedInChapter:section];
}

-(BOOL)isChapterNext:(NSInteger)chapter page:(NSInteger)page {
    return (page == [self.framesetter pagesForChapter:chapter]-1 && chapter < self.numChapters-1);
}

-(BOOL)isChapterPrev:(NSInteger)chapter page:(NSInteger)page {
    return (page == 0 && chapter > 0);
}

// You MUST reload the table view when generating pages, because the data (framesetter)
// is the only way we can know if they are loaded
-(void)ensurePagesForChapter:(NSInteger)chapter {
    // don't put the main_queue in here, because some functions require this to
    // happen in order!
    [self.framesetter ensurePagesForChapter:chapter];
    [self.collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // sizes correct at this point
    NSLog(@"CELL %i %i %@", indexPath.section, indexPath.item, self.framesetter);
    static NSString * cellId = @"BookPage";
    NSInteger chapter = indexPath.section;
    NSInteger page = indexPath.item;
    
    UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    // If we don't have any pages for this chapter, stop what we are doing, load the chapter, and reload
    if (![self.framesetter hasPagesForChapter:chapter]) {
        // freaks out if reloadData is called in this function, so delay it until done
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ensurePagesForChapter:chapter];
            // without scrolling it remembers its scroll offset, not the current cell and jumps back
            // when travelling backwards (loading chapter 1 after a memory warning)
            [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
        });
        return cell;
    }
    
    id ctFrame = [self.framesetter pageForChapter:chapter page:page];
    [(ReaderPageView*)cell setFrame:ctFrame chapter:chapter page:page];
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
