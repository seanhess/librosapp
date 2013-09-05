//
//  StorePopularVC.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StorePopularVC.h"
#import "AuthorService.h"
#import "BookService.h"
#import "MetricsService.h"
#import "GenreService.h"
#import "StoreSearchVC.h"

@interface StorePopularVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *libraryButton;
@end

@implementation StorePopularVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-icon-popular-selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-icon-popular"]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [MetricsService storePopularLoad];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    // reload the store. this is the first tab, so refresh.
    [[BookService shared] loadStore];
    [[AuthorService shared] load];
    [[GenreService shared] load];
    
    self.fetchRequest = [[BookService shared] popular];
    
    self.libraryButton.title = NSLocalizedString(@"Library",nil);
    self.title = NSLocalizedString(@"Popular",nil);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)didTapSearch:(id)sender {
    StoreSearchVC * search = [StoreSearchVC new];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:search];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
