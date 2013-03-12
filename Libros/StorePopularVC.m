//
//  StorePopularVC.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StorePopularVC.h"
#import "BookService.h"
#import "MetricsService.h"

@interface StorePopularVC ()

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
}

- (void)viewDidLoad
{
    // reload the store. this is the first tab, so refresh.
    [[BookService shared] loadStore];
    
    self.fetchRequest = [[BookService shared] popular];
    
    self.title = NSLocalizedString(@"Popular", @"Popular");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
