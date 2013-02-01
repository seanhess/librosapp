//
//  StoreAuthorsVC.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreAuthorsVC.h"
#import "AuthorService.h"
#import "ObjectStore.h"
#import "Author.h"
#import "StoreBookResultsVC.h"

@interface StoreAuthorsVC ()
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@end

@implementation StoreAuthorsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AuthorService shared] load];
    NSFetchRequest * request = [[AuthorService shared] allAuthors];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:ObjectStore.shared.context sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
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
    
    Author * author = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = author.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Author * author = [self.fetchedResultsController objectAtIndexPath:indexPath];
    StoreBookResultsVC * results = [StoreBookResultsVC new];
    results.fetchRequest = [[AuthorService shared] booksByAuthor:author.name];
    results.title = author.name;
    [self.navigationController pushViewController:results animated:YES];
}

@end
