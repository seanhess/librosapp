//
//  StoreTabsVC.m
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreTabsVC.h"
#import "LibraryVC.h"
#import "StoreDetailsVC.h"
#import "StoreGenresVC.h"

@interface StoreTabsVC ()

@end

@implementation StoreTabsVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender && [sender class] == [StoreDetailsVC class]) {
        LibraryVC * library = (LibraryVC*)((UINavigationController*)segue.destinationViewController).topViewController;
        StoreDetailsVC * details = (StoreDetailsVC*)sender;
        library.loadBook = details.book;
    }
}

@end
