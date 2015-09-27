//
//  DSSharedDoorsViewController.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColorCategory.h"
#import "DSData.h"
#import "sharedDoorsCell.h"

@interface DSSharedDoorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView *headerView;
    UILabel *headerTitleLabel;
    
    UITableView *sharedDoorsTable;
    NSMutableArray *sharedDoorsData;
    UIRefreshControl *sharedDoorsRefreshControl;
}

@end
