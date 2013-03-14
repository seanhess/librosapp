//
//  StoreGenresVC.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreGenresVC.h"
#import "GenreService.h"
#import "ObjectStore.h"
#import "Genre.h"
#import "StoreBookResultsVC.h"
#import "MetricsService.h"
#import "Appearance.h"

@interface StoreGenresVC ()
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@end

@implementation StoreGenresVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = NSLocalizedString(@"Genres", @"Genres");
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-icon-genres-selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-icon-genres"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = Appearance.background;
    
    [[GenreService shared] load];
    NSFetchRequest * request = [[GenreService shared] allGenres];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:ObjectStore.shared.context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

- (void)viewWillAppear:(BOOL)animated {
    [MetricsService storeGenresLoad];
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


#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Genre * genre = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = genre.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Genre * genre = [self.fetchedResultsController objectAtIndexPath:indexPath];
    StoreBookResultsVC * results = [StoreBookResultsVC new];
    results.fetchRequest = [[GenreService shared] booksByGenre:genre.name];
    results.title = genre.name;
    [self.navigationController pushViewController:results animated:YES];
}

@end
