//
//  DSAddUserView.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIColor+UIColorCategory.h"

@interface DSAddUserView : UIView {
    UIView *searchBackgroundView;
    UIImageView *searchFieldSearchIcon;
}

@property (nonatomic) PFObject *doorData;
@property (nonatomic) UITextField *searchField;
@property (nonatomic) UIButton *cancelSearchButton;
@property (nonatomic) CGRect origSearchFieldF;

@property (nonatomic) UITableView *mySearchTable;
@property (nonatomic) NSMutableArray *mySearchData;
@property (nonatomic) UIRefreshControl *mySearchRefresh;

- (id) initWithFrame:(CGRect)frame andData:(PFObject*)doorD;
- (void) setSearchColorsToGreen:(BOOL)isGreen;

@end
