//
//  DSLoginViewController.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIColor+UIColorCategory.h"
#import "DSData.h"
#import "HKCircularProgressView.h"

@interface DSLoginViewController : UIViewController <UITextFieldDelegate> {
    UIView *screenView;
    
    HKCircularProgressView *progressView;
    UIView *loadingView;
    UIView *errorView;
    
    UITextField *accountField;
    UITextField *passwordField;
}

@end
