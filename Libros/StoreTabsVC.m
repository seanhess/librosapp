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
#import "StoreSearchVC.h"

@interface StoreTabsVC () <UITabBarControllerDelegate, UITabBarDelegate>
@property (nonatomic, strong) UIViewController * currentController;
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
    self.delegate = self;
    // self.tabBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    return;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController * navController = (UINavigationController*)viewController;
    
    // they are all navigation controllers
    UIViewController * topController = navController.topViewController;
    if ([topController class] == [StoreSearchVC class]) {
        
        if (self.currentController)
            self.selectedViewController = self.currentController;
        else
            self.selectedIndex = 0;
        
        UINavigationController * search = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchNavController"];
        [(UINavigationController*)self.selectedViewController presentViewController:search animated:YES completion:nil];
        return;
    }
    
    self.currentController = viewController;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"SELECTING %i", self.selectedIndex);
    // selected index is currently equal to the OLD one
//    if (item.i == 3) {
//        self.selectedIndex = self.currentIndex;
//    }
}

@end
