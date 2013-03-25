//
//  StoreVC.m
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreBookResultsVC.h"
#import "BookService.h"
#import "Book.h"
#import "ObjectStore.h"
#import "UserService.h"
#import "StoreBookCell.h"
#import "StoreDetailsVC.h"
#import "StoreBookResultsFilterView.h"
#import "Appearance.h"

@interface StoreBookResultsVC () <StoreBookResultsFilterDelegate>

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic) BookFilter currentFilter;
@property (nonatomic, strong) NSPredicate * originalPredicate;
@property (nonatomic, strong) StoreBookResultsFilterView * filterView;

@end

@implementation StoreBookResultsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = Appearance.background;
    
    self.currentFilter = BookFilterEverything;
    self.originalPredicate = self.fetchRequest.predicate;
    [self generateFetchedResults];
    
    // needs to be ANY details view controller has this
    // not just the popular one :(
    
    // meh, just do it like this, or load it from its own nib
    
    self.filterView = [StoreBookResultsFilterView filterView];
    [self.filterView setDelegate:self];
    self.tableView.tableHeaderView = self.filterView;
    [self.tableView setContentOffset:CGPointMake(0, self.filterView.frame.size.height)];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSIndexPath * selectedRow = [self.tableView indexPathForSelectedRow];
    if (selectedRow)
        [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.filterView renderSelectedSegment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generateFetchedResults {
    NSPredicate * filterPredicate  = [BookService.shared filterByType:self.currentFilter];
    
    if (self.originalPredicate && filterPredicate) {
        self.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filterPredicate, self.originalPredicate]];
    }
    
    else if (self.originalPredicate)  {
        self.fetchRequest.predicate = self.originalPredicate;
    }
    
    else {
        self.fetchRequest.predicate = filterPredicate;
    }
    
    NSAssert(self.fetchRequest, @"Must set fetch request before viewDidLoad on StoreBookResultsVC");
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:ObjectStore.shared.context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSIndexPath*)localIndexPath:(NSIndexPath*)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreBookCell";
    StoreBookCell *cell = (StoreBookCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StoreBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:[self localIndexPath:indexPath]];
    cell.book = book;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STORE_BOOK_CELL_HEIGHT;
}

#pragma mark - Filtering

- (void)didSelectFilter:(BookFilter)filter {
    self.currentFilter = filter;
    [self generateFetchedResults];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Book * book = [self.fetchedResultsController objectAtIndexPath:[self localIndexPath:indexPath]];
    StoreDetailsVC * details = [StoreDetailsVC new];
    details.book = book;
    [self.navigationController pushViewController:details animated:YES];
}


@end
