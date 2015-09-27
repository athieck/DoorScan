//
//  sharedDoorsCell.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "sharedDoorsCell.h"

@implementation sharedDoorsCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 35)];
        _userNameLabel.text = @"";
        _userNameLabel.font = [UIFont fontWithName:@"Thonburi" size:21];
        _userNameLabel.textColor = [UIColor myLightBlackColor];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_userNameLabel];
        
        _doorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, [UIScreen mainScreen].bounds.size.width, 25)];
        _doorNameLabel.text = @"";
        _doorNameLabel.font = [UIFont fontWithName:@"Thonburi" size:15];
        _doorNameLabel.textColor = [UIColor myLightBlackColor];
        _doorNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_doorNameLabel];

    }
    return self;
}

@end
