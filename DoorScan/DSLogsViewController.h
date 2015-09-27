//
//  DSLogsViewController.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColorCategory.h"
#import "DSData.h"
#import "sharedDoorsCell.h"
#import "DSDoorLogView.h"
#import "logCell.h"
#import "DateTools.h"

@interface DSLogsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView *headerView;
    UILabel *headerTitleLabel;
    UIButton *backButton;

    UITableView *myDoorsTable;
    NSMutableArray *myDoorsData;
    UIRefreshControl *myDoorsRefreshControl;
    
    DSDoorLogView *myDoorLogView;
}

@end
