//
//  StoreFilterVC.m
//  Libros
//
//  Created by Sean Hess on 2/6/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreFilterVC.h"
#import "Appearance.h"

@interface StoreFilterVC ()

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@end

@implementation StoreFilterVC

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
	// Do any additional setup after loading the view.
    
    self.title = @"Filter Books";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.filter inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = Appearance.tableSelectedBackgroundView;
    }
    
    if (indexPath.row == BookFilterEverything) cell.textLabel.text = @"Everything";
    else if (indexPath.row == BookFilterHasText) cell.textLabel.text = @"Has Text";
    else if (indexPath.row == BookFilterHasAudio) cell.textLabel.text = @"Has Audio";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.filter = indexPath.row;
    [self.delegate didSelectFilter:self.filter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
