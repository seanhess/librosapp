//
//  LibraryVC.m
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "LibraryVC.h"
#import "BookService.h"
#import "FileService.h"
#import "UserService.h"
#import "Book.h"
#import "ObjectStore.h"
#import "ReaderVC.h"
#import "StoreBookCell.h"
#import "LibraryBookCoverCell.h"
#import "MetricsService.h"

@interface LibraryVC () <NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, strong) Book * selectedBook;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *layoutButton;
@end



@implementation LibraryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.collectionView registerClass:[LibraryBookCoverCell class] forCellWithReuseIdentifier:@"LibraryBookCover"];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:UserService.shared.libraryBooks managedObjectContext:ObjectStore.shared.context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
   
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [MetricsService libraryLoad];
    self.wantsFullScreenLayout = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.loadBook) {
        NSIndexPath * indexPath = [self.fetchedResultsController indexPathForObject:self.loadBook];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

- (IBAction)didTapLayoutButton:(id)sender {
    // hide the table and show the collection view!
    if (self.collectionView.hidden) {
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
        self.layoutButton.title = @"List";
        [MetricsService libraryListLayout];
    }
    else {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        self.layoutButton.title = @"Grid";
        [MetricsService libraryGridLayout];
    }
}


-(NSInteger)numberOfBooksInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfBooksInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreBookCell";
    StoreBookCell *cell = (StoreBookCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StoreBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.book = book;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [UserService.shared archiveBook:book];
    
    // Need to delete local files, otherwise, what is the point?
    
    [self.fetchedResultsController performFetch:nil];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Archive";
}


#pragma mark - Table view delegate

- (void)selectBookAtIndexPath:(NSIndexPath*)indexPath {
    Book * book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self showReader:book];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectBookAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// this gets called DURING first initialization
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfBooksInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // sizes correct at this point
    static NSString * cellId = @"LibraryBookCover";
    LibraryBookCoverCell * cell = (LibraryBookCoverCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // TODO add image view and WORK IT
    cell.book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(91, 130);
}

// This is the SECTION inset. not the cell inset. OHHHH
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(11, 11, 11, 11);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 11;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 11;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectBookAtIndexPath:indexPath];
}

- (void)showReader:(Book*)book {
    ReaderVC * readervc = [ReaderVC new];
    readervc.book = book;
    [self.navigationController pushViewController:readervc animated:YES];
}

@end
