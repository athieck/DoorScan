//
//  DSAddUserView.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSAddUserView.h"

@implementation DSAddUserView

- (id) initWithFrame:(CGRect)frame andData:(PFObject*)doorD {
    self = [super initWithFrame:frame];
    if (self) {
        _doorData = doorD;
        self.backgroundColor = [UIColor whiteColor];
        
        searchBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        searchBackgroundView.backgroundColor = [UIColor myGreenTheme3];
        [self addSubview:searchBackgroundView];
        
        _origSearchFieldF = CGRectMake(15, 5, self.frame.size.width - 30, 30);
        _searchField = [[UITextField alloc] initWithFrame: _origSearchFieldF];
        _searchField.placeholder = @"Search";
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor myGreenTheme3]}];
        _searchField.backgroundColor = [UIColor myGreenGrayColor];
        _searchField.textColor = [UIColor myLightGrayColor];
        _searchField.layer.cornerRadius = 6;
        
        _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchField.keyboardType = UIKeyboardTypeDefault;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        UIView *searchLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, _searchField.frame.size.height)];
        searchFieldSearchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        searchFieldSearchIcon.center = CGPointMake(searchLeftView.frame.size.width/2.0, searchLeftView.frame.size.height/2.0);
        searchFieldSearchIcon.image = [[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        searchFieldSearchIcon.tintColor = [UIColor myGreenTheme3];
        [searchLeftView addSubview:searchFieldSearchIcon];
        
        [_searchField setLeftViewMode:UITextFieldViewModeAlways];
        [_searchField setLeftView:searchLeftView];
        
        _cancelSearchButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 4, 50, 30)];
        _cancelSearchButton.backgroundColor = [UIColor myGreenTheme3];
        [_cancelSearchButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelSearchButton setTitleColor:[UIColor myLightGrayColor] forState:UIControlStateNormal];
        [_cancelSearchButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi" size:15]];
        _cancelSearchButton.alpha = 0.0;
        [self addSubview:_cancelSearchButton];
        
        [self addSubview:_searchField];
    
    }
    return self;
}

- (void) setSearchColorsToGreen:(BOOL)isGreen {
    if (isGreen) {
        searchBackgroundView.backgroundColor = [UIColor myGreenTheme3];
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor myGreenTheme3]}];
        _searchField.backgroundColor = [UIColor myGreenGrayColor];
        _searchField.textColor = [UIColor myLightGrayColor];
        searchFieldSearchIcon.tintColor = [UIColor myGreenTheme3];
        _cancelSearchButton.backgroundColor = [UIColor myGreenTheme3];
        
    } else {
        searchBackgroundView.backgroundColor = [UIColor myRedThemeColor];
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [UIColor myRedThemeColor]}];
        _searchField.backgroundColor = [UIColor myRedGrayColor];
        _searchField.textColor = [UIColor myLightGrayColor];
        searchFieldSearchIcon.tintColor = [UIColor myRedThemeColor];
        _cancelSearchButton.backgroundColor = [UIColor myRedThemeColor];
    }
    
}

@end
