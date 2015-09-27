//
//  DSSettingsViewController.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColorCategory.h"
#import <Parse/Parse.h>
#import "DSData.h"
#import "HKCircularProgressView.h"

@interface DSSettingsViewController : UIViewController {
    UIView *headerView;
    UILabel *headerTitleLabel;
    
    UIView *loadingView;
    HKCircularProgressView *progressView;
    UIView *errorView;

}

@end
