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
#import "LibraryVC.h"
#import "Settings.h"
#import "UserService.h"
#import "BookService.h"

#import <Parse/Parse.h>
#import <TestFlight.h>

@implementation AppDelegate

// does the app delegate OWN the objectStore?

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"95444ebe-ed2c-4e99-8e79-92541c05f85c"];
    
    NSDictionary * navigationTextAttributes = @{UITextAttributeTextColor: Appearance.lightGray};
    NSDictionary * tabBarTextAttributes = @{UITextAttributeTextColor: Appearance.darkTabBarColor};
    NSDictionary * tabBarSelectedAttributes = @{UITextAttributeTextColor: Appearance.lightTabBarColor};
    
    // GENERIC tab bar override
    UIImage *tabBarBackground = [UIImage imageNamed:@"tabbar-background"];
    UIImage *tabBarBackgroundSelected = [UIImage imageNamed:@"tabbar-background-selected"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:tabBarBackgroundSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarTextAttributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarSelectedAttributes forState:UIControlStateSelected];
    
    // GENERIC NAVIGATION BAR
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-bg.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:navigationTextAttributes];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-button.png"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"navbar-back-button.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // SEARCH BAR
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-bg.png"]];
    
    [[UISlider appearance] setMinimumTrackTintColor:Appearance.highlightBlue];
    [[UISwitch appearance] setOnTintColor:Appearance.highlightBlue];
    
    [[UIProgressView appearance] setTrackTintColor:Appearance.boringGrayColor];
    [[UIProgressView appearance] setProgressTintColor:Appearance.highlightBlue];
    // [[UISegmentedControl appearance] setTintColor:Appearance.highlightBlue]; (changes the whole background)
    
    [MetricsService launch];
    
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    NSLog(@"PARSE: %@", PARSE_MODE);
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    // DEBUG: uncomment to test push notifications working
    //[self loadStoreWithApplication:application];
    
    // No idea why it doesn't call didReceiveRemoteNotification on its own
    // This is only needed if they open a notification from a cold boot
    NSDictionary * remoteNotification = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (remoteNotification) [self application:application didReceiveRemoteNotification:remoteNotification];
    
    
    
    
    // get the first launch books yo!
    NSLog(@"FIRST LAUNCH - LOADING");
    if (!UserService.shared.hasFirstLaunchBooks) {
        [BookService.shared loadStoreWithCb:^{
            NSLog(@"FIRST LAUNCH - LOADED");
            // now add the 3 books
            NSArray * books = [BookService.shared firstRunBooks];
            [UserService.shared addBooks:books];
            [UserService.shared setHasFirstLaunchBooks];
        }];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"APN Registered");
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"APN FAIL %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    [self loadStoreWithApplication:application];
    [self resetBadge];
}

- (void)resetBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)loadStoreWithApplication:(UIApplication*)application {
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Store"];
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
