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

@interface ReaderVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ReaderFramesetterDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (nonatomic) NSInteger currentChapter;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat currentPercent;

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
    
    // TOO EARLY TO DRAW! View Size is wrong
    // you can call reloadData early and it doesn't fire twice
    NSLog(@"VIEW DID LOAD %@", NSStringFromCGRect(self.view.bounds));
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"VIEW WILL APPEAR %@", NSStringFromCGRect(self.view.bounds));
    // OK TO DRAW :D
    // Has correct size
    [self initReaderWithSize:self.collectionView.bounds.size chapter:1 page:1];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGRect(self.view.bounds));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.currentPercent = [self.framesetter percentThroughChapter:self.currentChapter page:self.currentPage];
    
    CGSize newSize = CGSizeMake(self.collectionView.frame.size.height, self.collectionView.frame.size.width); // well, depends on the orientation
    [self initReaderWithSize:newSize chapter:self.currentChapter page:self.currentPage];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    NSInteger newPage = [self.framesetter pageForChapter:self.currentChapter percent:self.currentPercent];
    self.currentPage = newPage;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"DID ROTATE %@", NSStringFromCGRect(self.collectionView.bounds));
    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
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
//    NSLog(@"MOVE TO %i %i", chapter, page);
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:chapter] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    // Calculate my own. That didn't always left-alignt the cells
    CGFloat cellWidth = self.collectionView.frame.size.width;
    NSInteger pageOffset = [self cellOffsetForChapter:chapter page:page];
    CGFloat totalOffsetX = cellWidth * pageOffset;
    [self.collectionView setContentOffset:CGPointMake(totalOffsetX, 0) animated:animated];
//    NSLog(@"SCROLLED %@", NSStringFromCGPoint(self.collectionView.contentOffset));
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


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentPage];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {}

// you MUST know the size at this point
// do not call too early!
- (void)initReaderWithSize:(CGSize)size chapter:(NSInteger)chapter page:(NSInteger)page {
    NSLog(@"INIT READER chapter=%i page=%i", chapter, page);
    self.currentChapter = chapter;
    self.currentPage = page;
    
    self.framesetter = [[ReaderFramesetter alloc] initWithSize:size];
    self.framesetter.delegate = self;
    [self.framesetter ensurePagesForChapter:chapter];
    
    NSLog(@" - (INIT) has pages? %i", [self.framesetter hasPagesForChapter:chapter]);
    
    // you MUST call reloadData after empty, right?
    // well, if you assume things are wrong
    NSLog(@" - (INIT) reload");
    [self.collectionView reloadData];
    [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
}

- (NSAttributedString*)textForChapter:(NSInteger)chapter {
    return [self.formatter textForFile:self.files[chapter]];
}

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
            [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
        });
    }
    
    else if ([self isChapterPrev:chapter page:page] && ![self.framesetter hasPagesForChapter:chapter-1]) {
        [self.framesetter ensurePagesForChapter:chapter-1];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self moveToChapter:self.currentChapter page:self.currentPage animated:NO];
        });
    }
}


- (NSInteger)cellsDisplayedInChapter:(NSInteger)chapter {
    if ([self.framesetter hasPagesForChapter:chapter]) {
        return [self.framesetter pagesForChapter:chapter];
    }
    else return 1;
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
            [self.framesetter ensurePagesForChapter:nextChapter];
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

        [self.framesetter ensurePagesForChapter:previousChapter];
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
    NSLog(@"TABLE RELOADING %i", self.numChapters);
    return self.numChapters;
}

// this gets called DURING first initialization
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"CELLS IN CHAPTER %i = %i", section, [self cellsDisplayedInChapter:section]);
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
    NSLog(@"CELL %i %i %@", indexPath.section, indexPath.item, self.framesetter);
    static NSString * cellId = @"BookPage";
    NSInteger chapter = indexPath.section;
    NSInteger page = indexPath.item;
    UICollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
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
