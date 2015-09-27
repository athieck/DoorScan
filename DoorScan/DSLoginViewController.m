//
//  DSLoginViewController.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSLoginViewController.h"

@implementation DSLoginViewController

- (id) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor myGreenTheme2];
        
    }
    return self;
}

- (void) viewDidLoad {
    screenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    screenView.backgroundColor = [UIColor myGreenTheme2];
    [self.view addSubview:screenView];
    
    UILabel *DStitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 80)];
    DStitleLabel.text = @"DoorScan";
    DStitleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:41];
    DStitleLabel.textAlignment = NSTextAlignmentCenter;
    DStitleLabel.textColor = [UIColor whiteColor];
    [screenView addSubview:DStitleLabel];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(15, 243, self.view.frame.size.width - 30, 85)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 4.0;
    [screenView addSubview:textView];
    
    accountField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, textView.frame.size.width - 20, 35)];
    accountField.font = [UIFont fontWithName:@"Thonburi" size:14];
    accountField.textColor = [UIColor blackColor];
    accountField.backgroundColor = [UIColor whiteColor];
    accountField.delegate = self;
    
    accountField.keyboardType = UIKeyboardTypeDefault;
    accountField.returnKeyType = UIReturnKeyNext;
    accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textView addSubview:accountField];
    
    if ([accountField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username or email" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, textView.frame.size.width - 20, 35)];
    passwordField.font = [UIFont fontWithName:@"Thonburi" size:14];
    passwordField.textColor = [UIColor blackColor];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textView addSubview:passwordField];
    
    if ([passwordField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor lightGrayColor];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, textView.frame.size.height/2.0 - 0.5, textView.frame.size.width, 1)];
    dividerView.backgroundColor = [UIColor myLightGrayColor];
    [textView addSubview:dividerView];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 337, self.view.frame.size.width - 30, 46)];
    [loginButton addTarget:self action:@selector(logUserIn) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [UIColor myGreenTheme3];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi" size:18]];
    loginButton.layer.cornerRadius = 4.0;
    [screenView addSubview:loginButton];
    
    UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 580, self.view.frame.size.width, 25)];
    [signUpButton setTitle:@"Sign Up for DoorScan" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi" size:13]];
    signUpButton.backgroundColor = [UIColor myGreenTheme2];
    [screenView addSubview:signUpButton];
}

- (void) logUserIn {
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
    [self createLoadingViewWithMessage:@"loading..."];
    [[DSData defaultData] logUsername:accountField.text andPassword:passwordField.text inWithCompletionBlock:^(NSError *error){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
        if (error) {
            [self removeLoadingView];
            [self showErrorWithTitle:@"Try again!" message0:@"The username or password" message1:@"was incorrect." andWide:YES];
        }
            
        }];
    }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == accountField) {
        [accountField resignFirstResponder];
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        [passwordField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^(void) {
            screenView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^(void) {
        screenView.frame = CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.view == screenView && (passwordField.isFirstResponder || accountField.isFirstResponder)) {
        [passwordField resignFirstResponder];
        [accountField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^(void) {
            screenView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            
        }];
    }
}

#pragma mark loading view
- (void) createLoadingViewWithMessage:(NSString*)message {
    loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor myDarkGrayTransparentColor];
    [self.view addSubview:loadingView];
    
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
    errorView = [[UIView alloc] initWithFrame:self.view.frame];
    errorView.backgroundColor = [UIColor myDarkGrayTransparentColor];
    [self.view addSubview:errorView];
    
    
    UIView *errorBackground;
    if (!isWide) {
        errorBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 130)];
    } else {
        errorBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 130)];
    }
    errorBackground.center = CGPointMake(errorView.frame.size.width/2.0, errorView.frame.size.height/2.0);
    errorBackground.backgroundColor = [UIColor myLightGrayColor];
    errorBackground.layer.cornerRadius = 5;
    errorBackground.layer.borderColor = [UIColor myGrayThemeColor].CGColor;
    errorBackground.layer.borderWidth = 1;
    [errorView addSubview:errorBackground];
    
    UILabel *errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorBackground.frame.size.width, 30)];
    errorMessageLabel.center = CGPointMake(errorBackground.frame.size.width/2.0, 31);
    errorMessageLabel.text = message0;
    errorMessageLabel.font = [UIFont fontWithName:@"Thonburi" size:17];
    errorMessageLabel.textColor = [UIColor myLightBlackColor];
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    [errorBackground addSubview:errorMessageLabel];
    
    UILabel *errorMessage2Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorBackground.frame.size.width, 30)];
    errorMessage2Label.center = CGPointMake(errorBackground.frame.size.width/2.0, 50);
    errorMessage2Label.text = message1;
    errorMessage2Label.font = [UIFont fontWithName:@"Thonburi" size:17];
    errorMessage2Label.textColor = [UIColor myLightBlackColor];
    errorMessage2Label.textAlignment = NSTextAlignmentCenter;
    [errorBackground addSubview:errorMessage2Label];
    
    UIButton *errorOkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    errorOkButton.frame = CGRectMake(0, 0, errorBackground.frame.size.width - 40, 40);
    errorOkButton.center = CGPointMake(errorBackground.frame.size.width/2.0, 100);
    [errorOkButton addTarget: self
                      action:@selector(removeError)
            forControlEvents:UIControlEventTouchUpInside];
    errorOkButton.backgroundColor = [UIColor myGreenTheme2];
    
    [errorOkButton setTitle:@"Ok" forState:UIControlStateNormal];
    [errorOkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [errorOkButton.titleLabel setFont:[UIFont fontWithName:@"Thonburi" size:20]];
    
    errorOkButton.layer.cornerRadius = 2;
    [errorBackground addSubview:errorOkButton];
}

- (void) removeError {
    [errorView removeFromSuperview];
}

@end
