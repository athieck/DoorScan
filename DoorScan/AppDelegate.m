//
//  AppDelegate.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/24/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"Muut7AbFD3ldWC1qSS8QBW0x2OyxcsvwMvCTqzwh"
                  clientKey:@"fIcUG6FKtSyzc2A58hVYn76WZtQEBhjEBdNMbWOA"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrPass) name:loginOrPassNotification object:nil];
    
    [self loginOrPass];
    
    return YES;
}

- (void) loginOrPass {
    //[[NSOperationQueue mainQueue] addOperationWithBlock:^{

    if (tabBarController) {
        tabBarController = nil;
    }
    
    tabBarController = [[UITabBarController alloc] init];
    
    if ([PFUser currentUser]) {
        NSLog(@"we have a user");
        
        myScanVC =  [[DSScanViewController alloc] init];
        UINavigationController *scanNavController = [[UINavigationController alloc] initWithRootViewController: myScanVC];
        
        myMyDoorsVC =  [[DSMyDoorsViewController alloc] init];
        UINavigationController *myDoorsNavController = [[UINavigationController alloc] initWithRootViewController: myMyDoorsVC];
        
        mySharedDoorsVC =  [[DSSharedDoorsViewController alloc] init];
        UINavigationController *sharedDoorsNavController = [[UINavigationController alloc] initWithRootViewController: mySharedDoorsVC];
        
        myLogsVC =  [[DSLogsViewController alloc] init];
        UINavigationController *logsNavController = [[UINavigationController alloc] initWithRootViewController: myLogsVC];
        
        mySettingsVC =  [[DSSettingsViewController alloc] init];
        UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController: mySettingsVC];
        
        tabBarController.viewControllers = [NSArray arrayWithObjects: scanNavController, myDoorsNavController, sharedDoorsNavController, logsNavController, settingsNavController, nil];
        
        tabBarController.selectedIndex = 0;
        tabBarController.delegate = self;
        
        UITabBarItem *scanItem = [[UITabBarItem alloc] initWithTitle:@"scan" image:[UIImage imageNamed:@"scan"] tag:0];
        [myScanVC  setTabBarItem:scanItem];
        
        UITabBarItem *myDoorsItem = [[UITabBarItem alloc] initWithTitle:@"my doors" image:[UIImage imageNamed:@"myDoors"] tag:1];
        [myMyDoorsVC  setTabBarItem:myDoorsItem];
        
        UITabBarItem *sharedDoorsItem = [[UITabBarItem alloc] initWithTitle:@"shared doors" image:[UIImage imageNamed:@"sharedDoors"] tag:2];
        [mySharedDoorsVC  setTabBarItem:sharedDoorsItem];
        
        UITabBarItem *logsItem = [[UITabBarItem alloc] initWithTitle:@"logs" image:[UIImage imageNamed:@"logs"] tag:3];
        [myLogsVC  setTabBarItem:logsItem];
        
        UITabBarItem *settingsItem = [[UITabBarItem alloc] initWithTitle:@"settings" image:[UIImage imageNamed:@"settings"] tag:4];
        [mySettingsVC  setTabBarItem:settingsItem];
        
        tabBarController.tabBar.barStyle = UIBarStyleDefault;
        [[UITabBar appearance] setTintColor:[UIColor myGreenTheme3]];
        [[UITabBar appearance] setBarTintColor:[UIColor myLightGrayColor]];
        
        self.window.rootViewController = tabBarController;
        
    } else {
        NSLog(@"we nave no user captain!");
        self.window.rootViewController = [[DSLoginViewController alloc] init];
    }

    //}];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
