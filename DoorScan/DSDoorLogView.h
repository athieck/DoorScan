//
//  DSDoorLogView.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIColor+UIColorCategory.h"

@interface DSDoorLogView : UIView

@property (nonatomic) UITableView *logTable;
@property (nonatomic) UIRefreshControl *logRefresh;
@property (nonatomic) NSMutableArray *logData;
@property (nonatomic) PFObject *doorData;
- (id) initWithFrame:(CGRect)frame andData:(PFObject *)doorD;

@end
