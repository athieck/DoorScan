//
//  DSDoorView.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSDoorView.h"

@implementation DSDoorView

- (id) initWithFrame:(CGRect)frame andData:(PFObject*)doorD andDelegate:(UIViewController*)parentController {
    self = [super initWithFrame:frame];
    if (self) {
        _doorData = doorD;
        _sharedWithData = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, self.frame.size.width, 34)];
        tableTitle.text = @"Shared";
        tableTitle.font = [UIFont fontWithName:@"Thonburi-Bold" size:24];
        tableTitle.textColor = [UIColor myLightBlackColor];
        tableTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tableTitle];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(300, -2, 50, 50)];
        [_shareButton setImage:[[UIImage imageNamed:@"plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_shareButton setTintColor:[UIColor myGreenTheme2]];
        
        [self addSubview:_shareButton];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 1)];
        divider.backgroundColor = [UIColor myGrayThemeColor];
        [self addSubview:divider];
        
    }
    return self;
}

- (void) lockUnlockDoorWithCompletionBlock:(void (^)(NSError *error)) completionBlock {
    [[DSData defaultData] submitRequestToDoorId:_doorData.objectId withCompletionBlock:^(PFObject *response, NSError *error) {
        if (!error) {
            _doorData = response;
            [self reloadScreen];
            completionBlock(nil);
        } else {
            completionBlock(error);
        }
    }];
}

- (void) reloadScreen {
    [[NSNotificationCenter defaultCenter] postNotificationName:changeDoorValue object:self];
    if (![_doorData[@"unlocked"] boolValue]) {
        unlockLockB.backgroundColor = [UIColor myGreenTheme3];
        [unlockLockB setTitle:@"Unlock" forState:UIControlStateNormal];
    } else {
        unlockLockB.backgroundColor = [UIColor myRedThemeColor];
        [unlockLockB setTitle:@"Lock" forState:UIControlStateNormal];
    }
}

#pragma mark loading view
- (void) createLoadingViewWithMessage:(NSString*)message {
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    loadingView.backgroundColor = [UIColor myDarkGrayTransparentColor];
    [self addSubview:loadingView];
    
    UIView *loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    loadingBackground.center = CGPointMake(loadingView.frame.size.width/2.0, loadingView.frame.size.height/2.0);
    loadingBackground.backgroundColor = [UIColor myLightGrayColor];
    loadingBackground.layer.cornerRadius = 30;
    loadingBackground.layer.borderColor = [UIColor myGrayThemeColor].CGColor;
    loadingBackground.layer.borderWidth = 1;
    [loadingView addSubview:loadingBackground];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingBackground.frame.size.width, 27)];
    loadingLabel.center = CGPointMake(70, 102);
    loadingLabel.text = message;
    loadingLabel.font = [UIFont fontWithName:@"Thonburi" size:20];
    loadingLabel.textColor = [UIColor myLightBlackColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [loadingBackground addSubview:loadingLabel];
    
    progressView = [[HKCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 67, 67)];
    progressView.center = CGPointMake(70, 48);
    progressView.fillRadiusPx = 19;
    progressView.step = 0.10f;
    progressView.progressTintColor = [UIColor magentaColor];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.outlineWidth = 1.0f;
    progressView.outlineTintColor = [UIColor myGreenTheme2];
    progressView.endPoint = [[HKCircularProgressEndPointSpike alloc] init];
    [loadingBackground addSubview:progressView];
    
    [progressView startAnimating];
}

- (void) removeLoadingView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        progressView = nil;
        [loadingView removeFromSuperview];
        loadingView = nil;
    }];
}

#pragma mark error messages to user
- (void) showErrorWithTitle:(NSString*)title message0:(NSString*)message0 message1:(NSString*)message1 andWide:(BOOL)isWide {
    errorView = [[UIView alloc] initWithFrame:self.frame];
    errorView.backgroundColor = [UIColor myDarkGrayTransparentColor];
    [self addSubview:errorView];
    
    
    UIView *errorBackground;
    if (!isWide) {
        errorBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 160)];
    } else {
        errorBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 160)];
    }
    errorBackground.center = CGPointMake(errorView.frame.size.width/2.0, errorView.frame.size.height/2.0);
    errorBackground.backgroundColor = [UIColor myLightGrayColor];
    errorBackground.layer.cornerRadius = 30;
    errorBackground.layer.borderColor = [UIColor myGrayThemeColor].CGColor;
    errorBackground.layer.borderWidth = 1;
    [errorView addSubview:errorBackground];
    
    UILabel *errorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorBackground.frame.size.width, 34)];
    errorTitleLabel.center = CGPointMake(errorBackground.frame.size.width/2.0, 20);
    errorTitleLabel.text = title;
    errorTitleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    errorTitleLabel.textColor = [UIColor myLightBlackColor];
    errorTitleLabel.textAlignment = NSTextAlignmentCenter;
    [errorBackground addSubview:errorTitleLabel];
    
    UILabel *errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorBackground.frame.size.width, 30)];
    errorMessageLabel.center = CGPointMake(errorBackground.frame.size.width/2.0, 55);
    errorMessageLabel.text = message0;
    errorMessageLabel.font = [UIFont fontWithName:@"Thonburi" size:20];
    errorMessageLabel.textColor = [UIColor myLightBlackColor];
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    [errorBackground addSubview:errorMessageLabel];
    
    UILabel *errorMessage2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorBackground.frame.size.width, 30)];
    errorMessage2Label.center = CGPointMake(errorBackground.frame.size.width/2.0, 80);
    errorMessage2Label.text = message1;
    errorMessage2Label.font = [UIFont fontWithName:@"Thonburi" size:20];
    errorMessage2Label.textColor = [UIColor myLightBlackColor];
    errorMessage2Label.textAlignment = NSTextAlignmentCenter;
    [errorBackground addSubview:errorMessage2Label];
    
    UIButton *errorOkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    errorOkButton.frame = CGRectMake(0, 0, 70, 40);
    errorOkButton.center = CGPointMake(errorBackground.frame.size.width/2.0, 130);
    [errorOkButton addTarget: self
                      action:@selector(removeError)
            forControlEvents:UIControlEventTouchUpInside];
    errorOkButton.backgroundColor = [UIColor myLightGrayColor];
    
    [errorOkButton setTitle:@"Ok" forState:UIControlStateNormal];
    [errorOkButton setTitleColor:[UIColor myGrayThemeColor] forState:UIControlStateNormal];
    [errorOkButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi" size:20]];
    
    errorOkButton.layer.cornerRadius = 10;
    errorOkButton.layer.borderColor=[UIColor myGrayThemeColor].CGColor;
    errorOkButton.layer.borderWidth=2.0f;
    [errorBackground addSubview:errorOkButton];
}

- (void) removeError {
    [errorView removeFromSuperview];
}

@end
