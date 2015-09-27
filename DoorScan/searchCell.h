//
//  searchCell.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "UIColor+UIColorCategory.h"

@interface searchCell : MGSwipeTableCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *permissionImage;

@end
