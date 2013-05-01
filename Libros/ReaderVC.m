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
#import "ReaderFontVC.h"
#import <AVFoundation/AVFoundation.h>
#import <WEPopover/WEPopoverController.h>
#import "MetricsService.h"
#import "Chapter.h"
#import "ReaderVolumeVC2.h"

#define STATUS_BAR_OFFSET 20
#define TAP_SEEK_TIME 15.0

@interface ReaderVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ReaderFramesetterDelegate, ReaderTableOfContentsDelegate, ReaderFontDelegate, AVAudioPlayerDelegate, WEPopoverControllerDelegate, ReaderVolumeDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) CGFloat currentPercent;

@property (strong, nonatomic) ReaderFramesetter * framesetter;
@property (strong, nonatomic) ReaderFormatter * formatter;
@property (strong, nonatomic) NSArray * chapters;

@property (nonatomic) BOOL scrolling;

@property (weak, nonatomic) IBOutlet UIView *bottomControlsView;
@property (weak, nonatomic) IBOutlet UIView *topControlsView;
@property (weak, nonatomic) IBOutlet UIImageView *topControlsBackground;
@property (weak, nonatomic) IBOutlet UIButton *fontButton;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitle;

@property (weak, nonatomic) IBOutlet UISlider *pageSlider;
@property (weak, nonatomic) IBOutlet UILabel *pagesDoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pagesLeftLabel;

@property (strong, nonatomic) ReaderFontVC * fontController;
@property (strong, nonatomic) WEPopoverController * popover;

@property (strong, nonatomic) NSTimer * playbackTimer;
@property (strong, nonatomic) AVAudioPlayer * player;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UISlider *audioProgress;
@property (weak, nonatomic) IBOutlet UILabel *audioTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioRemainingLabel;

@property (nonatomic) float currentRate;
@property (nonatomic) float currentVolume;

@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (strong, nonatomic) WEPopoverController * volumePopover;
@property (weak, nonatomic) IBOutlet UIView *audioOnlyView;
@property (weak, nonatomic) IBOutlet UITextView *audioOnlyText;

@property (strong, nonatomic) NSTimer * hideControlsTimer;

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
    
    [MetricsService readerLoadedBook:self.book];
    
    self.audioOnlyText.text = NSLocalizedString(@"Audio Only",nil);
    
    self.fontController = [ReaderFontVC new];
    self.fontController.delegate = self;
    
    self.currentVolume = 1.0;
    // self.volumeSlider.value = self.currentVolume;
    
    self.currentRate = 1.0;
    
    [self.collectionView registerClass:[ReaderPageView class] forCellWithReuseIdentifier:@"BookPage"];
    
    FileService * fs = [FileService shared];
    
    self.title = self.book.title;
    self.bookTitle.text = self.book.title;
    self.chapters = [fs chaptersForFiles:[fs byBookId:self.book.bookId]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self updateControlsFromBook];
    
    // INITIALIZE
    self.formatter = [ReaderFormatter new];
    
    // TOO EARLY TO DRAW! View Size is wrong
    // you can call reloadData early and it doesn't fire twice
    NSError * error = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) NSLog(@"AV ERROR setCategory %@", error);
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) NSLog(@"AV ERROR setActive %@", error);
    
    //Direct audio to speakers when there is no headphone
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
}

- (void)viewWillAppear:(BOOL)animated {
    // OK TO DRAW - has correct size (IF you set navigation bar hidden to the same thing here as in viewDidLoad
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self newFramesetterWithSize:self.collectionView.bounds.size];
    
    [self ensurePagesForChapter:self.book.currentChapter];
    [self moveToChapter:self.book.currentChapter page:self.book.currentPage animated:NO];
    [self playerAtChapter:self.book.currentChapter];
    if (self.book.currentTime) {
        self.player.currentTime = self.book.currentTime;
        [self.player play];
        [self updateAudioProgress];
    }
    
    Chapter * chapter = self.chapters[self.book.currentChapter];
    if (chapter.textFile) [self hideControlsInABit];
}

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"VIEW DID APPEAR %@", NSStringFromCGRect(self.view.bounds));
    [super viewDidAppear: animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.playbackTimer invalidate];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize newSize;
    CGSize oldSize = self.collectionView.bounds.size;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        newSize.width = MAX(oldSize.width, oldSize.height);
        newSize.height = MIN(oldSize.width, oldSize.height) - STATUS_BAR_OFFSET;
    }
    else {
        newSize.width = MIN(oldSize.width, oldSize.height);
        newSize.height = MAX(oldSize.width, oldSize.height) - STATUS_BAR_OFFSET;
    }
    
    [self prepareLayoutWithSize:newSize];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    NSLog(@"DID ROTATE %@", NSStringFromCGRect(self.collectionView.bounds));
    [self commitLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.framesetter emptyExceptChapter:self.book.currentChapter];
    
    // not sure if these are actually necessary
    [self ensurePagesForChapter:self.book.currentChapter];
    [self moveToChapter:self.book.currentChapter page:self.book.currentPage animated:NO];
}

- (void)prepareLayoutWithSize:(CGSize)size {
    CGFloat currentPercent = [self.framesetter percentThroughChapter:self.book.currentChapter page:self.book.currentPage];
    
    // creates a new framesetter, does NOT currently load the table or chapter
    [self newFramesetterWithSize:size];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.alpha = 0.0;
    }];
    
    [self ensurePagesForChapter:self.book.currentChapter];
    self.book.currentPage = [self.framesetter pageForChapter:self.book.currentChapter percent:currentPercent];
}

- (void)commitLayout {
    [self moveToChapter:self.book.currentChapter page:self.book.currentPage animated:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.alpha = 1.0;
    }];
}

- (void)newFramesetterWithSize:(CGSize)size {
    self.framesetter = [[ReaderFramesetter alloc] initWithSize:size];
    self.framesetter.delegate = self;
}

- (void)updateControlsFromBook {
    self.bottomControlsView.hidden = (self.book.audioFiles ==  0);
}

- (void)updateControlsFromChapter {
    Chapter * chapter = self.chapters[self.book.currentChapter];
    self.fontButton.hidden = (chapter.textFile == nil);
    self.pageSlider.enabled = (chapter.textFile != nil); // CAN'T REPRODUCE - the thing is not enabling correctly
    self.collectionView.hidden = (chapter.textFile == nil);
    self.audioOnlyView.hidden = !self.collectionView.hidden;
}

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapToC:(id)sender {
    ReaderTableOfContentsVC * toc = [ReaderTableOfContentsVC new];
    [MetricsService readerTappedToc:self.book];
    toc.chapters = self.chapters;
    toc.currentChapter = self.book.currentChapter;
    toc.delegate = self;
    [self.navigationController presentViewController:toc animated:YES completion:nil];
    [self cancelHideControls];
}

-(void)didCloseToc {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectChapter:(NSInteger)chapter {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self loadChapter:chapter];
    [MetricsService readerSwitchedTocChapter:self.book chapter:chapter];
}

- (void)loadChapter:(NSInteger)chapter {
    if (chapter < 0) return;
    if (chapter >= self.chapters.count) return;
    
    BOOL playing = self.player.playing;
    
    NSLog(@"LOADING CHAPTER %i playing=%i", chapter, playing);
    
    self.book.currentChapter = chapter;
    self.book.currentPage = 0;
    [self ensurePagesForChapter:chapter];
    [self moveToChapter:chapter page:0 animated:NO];
    [self playerAtChapter:chapter];
    // don't hide controls here. It doesn't make sense after TOC change or chapter advance (audio)
    
    if (playing) [self.player play];
}

- (IBAction)didTapLibrary:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapFont:(id)sender {
    // gotta give it some size to start?
    self.fontController.view.frame = CGRectMake(0, 0, 100, 100);
    self.popover = [[WEPopoverController alloc] initWithContentViewController:self.fontController];
    [self.popover presentPopoverFromRect:self.fontButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.popover.delegate = self;
    [MetricsService readerTappedFont];
    self.fontButton.selected = YES;
    [self cancelHideControls];
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    self.fontButton.selected = NO;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    return YES;
}

- (void)didChangeFont {
    [MetricsService readerChangedFont:self.fontController.currentFace size:self.fontController.currentSize];
    [self prepareLayoutWithSize:self.view.bounds.size];
    [self commitLayout];
}

- (IBAction)didTapText:(UITapGestureRecognizer*)tap {
    
    // you can't hide it if the current chapter doesn't have anything
    Chapter * chapter = self.chapters[self.book.currentChapter];
    if (!chapter.textFile) return;
    
    if (self.isControlsShown) {
        [self hideControls];
        return;
    }
    
    if (!self.scrollViewIsAtRest) return;
    
    CGPoint point = [tap locationInView:self.view];
    
    NSIndexPath * newLocation = nil;
    
    if (point.x > 0.8*self.view.bounds.size.width) {
        newLocation = [self next:self.book.currentChapter page:self.book.currentPage];
    }
    
    else if (point.x < 0.2*self.view.bounds.size.width) {
        newLocation = [self prev:self.book.currentChapter page:self.book.currentPage];
    }
    
    else {
        [self showControls];
    }
    
    if (newLocation) {
        // reset the position to its new location after reloading the table (happens in next/prev)
        [self.collectionView setContentOffset:CGPointMake([self xOffsetForChapter:self.book.currentChapter page:self.book.currentPage], 0) animated:NO];
        // now animate to the new one
        [self moveToChapter:newLocation.section page:newLocation.item animated:YES];
    }
}

// These gestures were really weird
- (IBAction)didSwipeUp:(id)sender {
    return;
    NSIndexPath * newLocation = [self next:self.book.currentChapter page:self.book.currentPage];
    if (newLocation) [self moveToChapter:newLocation.section page:newLocation.item animated:YES];
}

- (IBAction)didSwipeDown:(id)sender {
    return;
    NSIndexPath * newLocation = [self prev:self.book.currentChapter page:self.book.currentPage];
    if (newLocation) [self moveToChapter:newLocation.section page:newLocation.item animated:YES];
}

- (void)moveToChapter:(NSInteger)chapter page:(NSInteger)page animated:(BOOL)animated {
//    NSLog(@"MOVE TO %i %i", chapter, page);
    
    // This doesn't always left-align the cells, calculate your own, below
    // [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:chapter] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    [self.collectionView setContentOffset:CGPointMake([self xOffsetForChapter:chapter page:page], 0) animated:animated];
    
    // Update the variables as well
    self.book.currentChapter = chapter;
    self.book.currentPage = page;
    
    [self displayChapter];
    [self displayPage];
}

- (NSInteger)cellOffsetForChapter:(NSInteger)chapter page:(NSInteger)page {
    NSInteger pages = 0;
    
    for (int c = 0; c < chapter; c++) {
        pages += [self cellsDisplayedInChapter:c];
    }
    
    // make sure you don't go too far!
    // if you switch orientations, and come back in to the book, it'll try to go to a page
    // that is past the end of the chapter
    NSInteger currentChapterPages = [self cellsDisplayedInChapter:chapter];
    if (page < currentChapterPages)
        pages += page;
    else
        pages += currentChapterPages-1;
    return pages;
}

- (CGFloat)xOffsetForChapter:(NSInteger)chapter page:(NSInteger)page {
    CGFloat cellWidth = self.collectionView.frame.size.width;
    NSInteger pageOffset = [self cellOffsetForChapter:chapter page:page];
    CGFloat totalOffsetX = cellWidth * pageOffset;
    return totalOffsetX;
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
//    [self moveToChapter:self.book.currentChapter page:self.book.currentPage animated:NO];
}

- (NSAttributedString*)textForChapter:(NSInteger)chapterIndex {
    if (chapterIndex < 0 || chapterIndex >= self.chapters.count) return nil;
    Chapter * chapter = self.chapters[chapterIndex];
    if (!chapter.textFile) return nil;
    return [self.formatter textForFile:chapter.textFile withFont:self.fontController.currentFace fontSize:self.fontController.currentSize];
}

- (void)updateCurrentPage {
    // only call this when at rest, or it gets confused
    // which page is in the MIDDLE of the window?
    NSIndexPath * cellIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + self.view.frame.size.width/2, 0)];
    NSInteger chapter = cellIndexPath.section;
    NSInteger page = cellIndexPath.item;
    
    // not sure what to do with this. Should it advance the audio???
//    if (self.book.currentChapter != chapter) {}
    
    self.book.currentChapter = chapter;
    self.book.currentPage = page;
    [self displayChapter];
    [self displayPage];
}

- (void)displayChapter {
    if (self.book.currentChapter >= self.chapters.count) return;
    Chapter * chapter = self.chapters[self.book.currentChapter];
    self.chapterTitle.text = chapter.name;
    [self updateControlsFromChapter];
}

- (void)displayPage {
    NSInteger totalPages = [self.framesetter pagesForChapter:self.book.currentChapter];
    self.pageSlider.value = (float) (self.book.currentPage) / (totalPages-1);
    self.pagesDoneLabel.text = [NSString stringWithFormat:@"%i", self.book.currentPage];
    NSInteger pagesLeft = totalPages-self.book.currentPage-1;
    if (pagesLeft < 0) pagesLeft = 0;
    self.pagesLeftLabel.text = [NSString stringWithFormat:@"%i", pagesLeft];
}

- (IBAction)didSlidePage:(id)sender {
    NSInteger totalPages = [self.framesetter pagesForChapter:self.book.currentChapter];
    NSInteger page = self.pageSlider.value * (totalPages-1);
    [self moveToChapter:self.book.currentChapter page:page animated:NO];
    [self cancelHideControls];
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
        if (nextChapter >= self.chapters.count)
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
    return (self.bottomControlsView.frame.origin.y < self.view.frame.size.height);
}

- (void)cancelHideControls {
    [self.hideControlsTimer invalidate];
    self.hideControlsTimer = nil;
}

- (void)hideControlsInABit {
    self.hideControlsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}

- (void)hideControls {
    [self.popover dismissPopoverAnimated:YES];
    [self.volumePopover dismissPopoverAnimated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect bottomFrame = self.bottomControlsView.frame;
        bottomFrame.origin.y = self.view.frame.size.height;
        self.bottomControlsView.frame = bottomFrame;
        
        CGRect topFrame = self.topControlsView.frame;
        topFrame.origin.y = -topFrame.size.height;
        self.topControlsView.frame = topFrame;
    }];
}

- (void)showControls {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect bottomFrame = self.bottomControlsView.frame;
        bottomFrame.origin.y = self.view.frame.size.height - bottomFrame.size.height;
        self.bottomControlsView.frame = bottomFrame;
        
        CGRect topFrame = self.topControlsView.frame;
        topFrame.origin.y = 0;
        self.topControlsView.frame = topFrame;
    }];
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.chapters.count;
}

// this gets called DURING first initialization
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self cellsDisplayedInChapter:section];
}

-(BOOL)isChapterNext:(NSInteger)chapter page:(NSInteger)page {
    return (page == [self.framesetter pagesForChapter:chapter]-1 && chapter < self.chapters.count-1);
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
//    NSLog(@"CELL %i %i %@", indexPath.section, indexPath.item, self.framesetter);
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
            [self moveToChapter:self.book.currentChapter page:self.book.currentPage animated:NO];
        });
        return cell;
    }
    
    id ctFrame = [self.framesetter pageForChapter:chapter page:page];
    [(ReaderPageView*)cell setFrame:ctFrame chapter:chapter page:page];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.collectionView.bounds.size;
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
















/// AUDIO STUFFF

- (void)playerAtChapter:(NSInteger)chapter {
    File * audioFile = [self audioFileForChapter:chapter];
    NSData * data = [FileService.shared readAsData:audioFile];
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.enableRate = YES;
    self.player.rate = self.currentRate;
    self.player.delegate = self;
    self.player.volume = self.currentVolume;
    [self.playbackTimer invalidate];
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onPlaybackTimer) userInfo:nil repeats:YES];
    
    self.audioProgress.value = 0;
    [self updateAudioProgress];
    
    self.playButton.enabled = (audioFile != nil);
    self.audioRemainingLabel.enabled = (audioFile != nil);
    self.audioTimeLabel.enabled = (audioFile != nil);
    self.audioProgress.enabled = (audioFile != nil);
}

- (File*)audioFileForChapter:(NSInteger)chapterIndex {
    if (chapterIndex < 0 || chapterIndex >= self.chapters.count) return nil;
    Chapter * chapter = self.chapters[chapterIndex];
    return chapter.audioFile;
}

- (IBAction)didClickPlay:(id)sender {
    [self togglePlayPauseAudio];
}

- (void)playAudio {
    if (!self.player) {
        [MetricsService readerPlayedAudio:self.book];
        [self playerAtChapter:self.book.currentChapter];
    }
    
    [self.player play];
    [self updatePlayButton];
}

- (void)pauseAudio {
    [self.player pause];
    [self updatePlayButton];
}

- (void)togglePlayPauseAudio {
    if (self.player.isPlaying){
        [self pauseAudio];
    }
    
    else {
        [self playAudio];
    }
}

- (IBAction)didClickRate:(id)sender {
    if (self.currentRate == 0.5) self.currentRate = 1.0;
    else if (self.currentRate == 1.0) self.currentRate = 1.5;
    else if (self.currentRate == 1.5) self.currentRate = 2.0;
    else self.currentRate = 0.5;
    
    self.player.rate = self.currentRate;
    NSString * rateImage;
    if (self.currentRate == 0.5) rateImage = @"reader-speed-icon-0.5.png";
    else if (self.currentRate == 1.0) rateImage = @"reader-speed-icon-1.png";
    else if (self.currentRate == 1.5) rateImage = @"reader-speed-icon-1.5.png";
    else rateImage = @"reader-speed-icon-2.png";
    [self.rateButton setImage:[UIImage imageNamed:rateImage] forState:UIControlStateNormal];
    [MetricsService readerChangedRate:self.currentRate];
}

- (IBAction)didClickRewind:(id)sender {
    [self rewind];
}

- (IBAction)didClickFastForward:(id)sender {
    [self fastForward];
}

- (IBAction)didClickVolume:(id)sender {
    ReaderVolumeVC2 * volume = [[ReaderVolumeVC2 alloc] init];
    volume.delegate = self;
    volume.value = self.currentVolume;
    CGRect buttonFrame = [self.view convertRect:self.volumeButton.frame fromView:self.bottomControlsView];
    self.volumePopover = [[WEPopoverController alloc] initWithContentViewController:volume];
    self.volumePopover.popoverContentSize = volume.view.frame.size;
    [self.volumePopover presentPopoverFromRect:buttonFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)fastForward {
    if (self.player.currentTime > self.player.duration - TAP_SEEK_TIME)
        [self nextTrack];
    
    else {
        self.player.currentTime += TAP_SEEK_TIME;
        [self updateAudioProgress];
    }
}

- (void)rewind {
    if (self.player.currentTime < TAP_SEEK_TIME)
        [self prevTrack];
    
    self.player.currentTime -= TAP_SEEK_TIME;
    [self updateAudioProgress];
}

- (void)nextTrack {
    [self loadChapter:self.book.currentChapter+1];
}

- (void)prevTrack {
    [self loadChapter:self.book.currentChapter-1];
}

- (void)onPlaybackTimer {
    if (self.audioProgress.isTracking) return;
    [self updateAudioProgress];
}

- (void)updateAudioProgress {
    self.audioTimeLabel.text = [self formatTime:self.player.currentTime];
    self.audioRemainingLabel.text = [NSString stringWithFormat:@"-%@", [self formatTime:self.player.duration - self.player.currentTime]];
    self.audioProgress.value = self.player.currentTime / self.player.duration;
    if (self.player.currentTime != 0)
        self.book.currentTime = self.player.currentTime;
    [self updatePlayButton];
}

- (void)updatePlayButton {
    if (self.player.isPlaying)
        [self.playButton setImage:[UIImage imageNamed:@"reader-pause-icon.png"] forState:UIControlStateNormal];
    else
        [self.playButton setImage:[UIImage imageNamed:@"reader-play-icon.png"] forState:UIControlStateNormal];
}

-(NSString*)formatTime:(float)time{
    int minutes = time / 60;
    int seconds = (int)time % 60;
    return [NSString stringWithFormat:@"%@%d:%@%d", minutes / 10 ? [NSString stringWithFormat:@"%d", minutes / 10] : @"", minutes % 10, [NSString stringWithFormat:@"%d", seconds / 10], seconds % 10];
}

- (IBAction)didSlideAudio:(id)sender {
    NSTimeInterval currentTime = self.audioProgress.value * self.player.duration;
    self.player.currentTime = currentTime;
    [self updateAudioProgress];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    // Not sure if I need to do something. Pause I guess?
    // Does it resume for me?
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.audioProgress.tracking) return;
    [self updateAudioProgress];
    if (!flag) return;
    [self loadChapter:self.book.currentChapter+1];
    if (self.book.currentChapter < self.chapters.count)
        [self.player play];
}

-(void)didSlideVolume:(CGFloat)value {
    self.currentVolume = value;
    self.player.volume = value;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
            [self playAudio];
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
            [self pauseAudio];
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
            [self togglePlayPauseAudio];
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
            [self nextTrack];
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
            [self prevTrack];
    }
}

@end
