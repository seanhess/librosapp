//
//  StorePopularVC.m
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StorePopularVC.h"
#import "BookService.h"

@interface StorePopularVC ()

@end

@implementation StorePopularVC

- (void)viewDidLoad
{
    // reload the store. this is the first tab, so refresh.
    [[BookService shared] loadStore];
    
    self.fetchRequest = [[BookService shared] popular];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
