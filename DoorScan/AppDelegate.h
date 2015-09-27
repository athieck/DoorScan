//
//  AppDelegate.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/24/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLoginViewController.h"
#import "UIColor+UIColorCategory.h"
#import "Constants.h"

#import "DSScanViewController.h"
#import "DSMyDoorsViewController.h"
#import "DSSharedDoorsViewController.h"
#import "DSLogsViewController.h"
#import "DSSettingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate> {
    UITabBarController *tabBarController;

    DSScanViewController *myScanVC;
    DSMyDoorsViewController *myMyDoorsVC;
    DSSharedDoorsViewController *mySharedDoorsVC;
    DSLogsViewController *myLogsVC;
    DSSettingsViewController *mySettingsVC;
    
}

@property (strong, nonatomic) UIWindow *window;


@end

