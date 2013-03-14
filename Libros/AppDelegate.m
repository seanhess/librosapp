//
//  AppDelegate.m
//  Libros
//
//  Created by Sean Hess on 1/8/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectStore.h"
#import "ReaderFormatter.h"
#import "IAPurchaseCommand.h"
#import "MetricsService.h"
#import "Appearance.h"


@implementation AppDelegate

// does the app delegate OWN the objectStore?

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary * navigationTextAttributes = @{UITextAttributeTextColor: Appearance.lightGray};
    
    // GENERIC tab bar override
    UIImage *tabBarBackground = [UIImage imageNamed:@"tabbar-background"];
    UIImage *tabBarBackgroundSelected = [UIImage imageNamed:@"tabbar-background-selected"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:tabBarBackgroundSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:navigationTextAttributes forState:UIControlStateNormal];
    
    // GENERIC NAVIGATION BAR
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-bg.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:navigationTextAttributes];
    
    [MetricsService launch];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[ObjectStore shared] saveContext];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[ObjectStore shared] saveContext];
    NSLog(@"WILL TERMINATE");
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
