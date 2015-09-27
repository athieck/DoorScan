//
//  DSDoorView.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIColor+UIColorCategory.h"
#import "HKCircularProgressView.h"
#import "DSData.h"
#import "Constants.h"

@interface DSDoorView : UIView {
    UIButton *unlockLockB;
    
    UIView *loadingView;
    HKCircularProgressView *progressView;
    UIView *errorView;
    
    UIViewController *superView;
}

- (void) lockUnlockDoorWithCompletionBlock:(void (^)(NSError *error)) completionBlock;

@property (nonatomic) PFObject *doorData;
@property (nonatomic) UITableView *sharedWithTable;
@property (nonatomic) NSMutableArray *sharedWithData;
@property (nonatomic) UIRefreshControl *sharedWithRefresh;
@property (nonatomic) UIButton *shareButton;

- (id) initWithFrame:(CGRect)frame andData:(PFObject*)doorD andDelegate:(UIViewController*)parentController;

@end
