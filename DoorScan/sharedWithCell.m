//
//  sharedWithCell.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "sharedWithCell.h"

@implementation sharedWithCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont fontWithName:@"Thonburi" size:21];
        _nameLabel.textColor = [UIColor myLightBlackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

@end
