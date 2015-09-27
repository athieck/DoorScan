//
//  logCell.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColorCategory.h"

@interface logCell : UITableViewCell

@property (nonatomic) UIImageView *statusImage;
@property (nonatomic) UILabel *userNameLabel;
@property (nonatomic) UILabel *timeStampLabel;

@end
