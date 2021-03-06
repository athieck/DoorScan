//
//  myDoorsCell.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+UIColorCategory.h"

@interface myDoorsCell : UITableViewCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *leftImage;
@property (nonatomic) UIImageView *rightImage;

- (void) setLocked:(BOOL)isLocked;

@end
