//
//  DSMyDoorsViewController.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSData.h"
#import "UIColor+UIColorCategory.h"
#import "myDoorsCell.h"
#import "sharedWithCell.h"
#import "DSDoorView.h"
#import "Constants.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "DSAddUserView.h"
#import "searchCell.h"
#import "HKCircularProgressView.h"

@interface DSMyDoorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MGSwipeTableCellDelegate, UITextFieldDelegate> {
    UIView *headerView;
    UILabel *headerTitleLabel;
    UIButton *backButton;
    UIImageView *doorStatusIcon;
    UIButton *doorStatusButton;
    
    UITableView *myDoorsTable;
    NSMutableArray *myDoorsData;
    UIRefreshControl *myDoorsRefreshControl;
    
    DSDoorView *myDoorView;
    DSAddUserView *myAddUsersView;
    
    HKCircularProgressView *progressView;
    UIView *loadingView;
    
    UIView *errorView;
    
    BOOL isLoading;
    BOOL isInBase;
    
}

@end
