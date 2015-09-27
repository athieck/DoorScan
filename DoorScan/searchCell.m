//
//  searchCell.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "searchCell.h"

@implementation searchCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, [UIScreen mainScreen].bounds.size.width - 70, 50)];
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont fontWithName:@"Thonburi" size:21];
        _nameLabel.textColor = [UIColor myLightBlackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        
        _permissionImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        [self.contentView addSubview:_permissionImage];
    }
    return self;
}

@end
