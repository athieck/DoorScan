//
//  DSDoorLogView.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSDoorLogView.h"

@implementation DSDoorLogView

- (id) initWithFrame:(CGRect)frame andData:(PFObject *)doorD {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _doorData = doorD;
    }
    return self;
}

@end
