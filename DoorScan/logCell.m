//
//  logCell.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "logCell.h"

@implementation logCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.width - 44, 31)];
        _userNameLabel.text = @"";
        _userNameLabel.font = [UIFont fontWithName:@"Thonburi" size:21];
        _userNameLabel.textColor = [UIColor myLightBlackColor];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_userNameLabel];
        
        _timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 30, [UIScreen mainScreen].bounds.size.width - 44, 25)];
        _timeStampLabel.text = @"";
        _timeStampLabel.font = [UIFont fontWithName:@"Thonburi" size:17];
        _timeStampLabel.textColor = [UIColor myLightBlackColor];
        _timeStampLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeStampLabel];
        
        _statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 25)];
        _statusImage.center = CGPointMake(35, 29);
        [self addSubview:_statusImage];
    }
    return self;
}


@end
