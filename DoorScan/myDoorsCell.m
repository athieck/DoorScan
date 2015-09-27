//
//  myDoorsCell.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/26/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "myDoorsCell.h"

@implementation myDoorsCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 35)];
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont fontWithName:@"Thonburi" size:24];
        _nameLabel.textColor = [UIColor myLightBlackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 25)];
        _leftImage.center = CGPointMake(70, 29);
        [self addSubview:_leftImage];
        
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 25)];
        _rightImage.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 70, 29);
        [self addSubview:_rightImage];
    }
    return self;
}

- (void) setLocked:(BOOL)isLocked {
    if (!isLocked) {
        _leftImage.image = [[UIImage imageNamed:@"unlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _rightImage.image = [[UIImage imageNamed:@"unlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _leftImage.tintColor = [UIColor myGreenTheme3];
        _rightImage.tintColor = [UIColor myGreenTheme3];

    } else {
        _leftImage.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _rightImage.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _leftImage.tintColor = [UIColor myRedThemeColor];
        _rightImage.tintColor = [UIColor myRedThemeColor];
    }
}

@end
