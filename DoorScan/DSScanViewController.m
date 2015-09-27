//
//  DSScanViewController.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DSScanViewController.h"

@interface DSScanViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
    
    UIButton *_uploadButton;
    UIView *loadingView;
    UIView *errorView;
    HKCircularProgressView *progressView;
}
@end

@implementation DSScanViewController

- (id) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor myGreenTheme4].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"";
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];

    _uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - 35, self.view.frame.size.height/2.0 + 200, 70, 70)];
    [_uploadButton addTarget:self action:@selector(uploadDoorId) forControlEvents:UIControlEventTouchUpInside];
    _uploadButton.backgroundColor = [UIColor myGreenTheme3];
    
    _uploadButton.layer.cornerRadius = 35.0;
    _uploadButton.layer.borderWidth = 1.0;
    _uploadButton.layer.borderColor = [UIColor myLightGrayColor].CGColor;
    
    [self.view addSubview:_uploadButton];
    [self.view bringSubviewToFront:_uploadButton];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            if (myTimer) {
                [myTimer invalidate];
                myTimer = nil;
            }
            myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                       target: self
                                                     selector:@selector(resetLabel)
                                                     userInfo: nil repeats:NO];
            break;
        }
        else
            _label.text = @"";
    }
    
    _highlightView.frame = highlightViewRect;
    NSLog(@"code detected");
}

- (void) resetLabel {
    _label.text = @"";
    [myTimer invalidate];
    myTimer = nil;
}

#pragma mark actions!
- (void) uploadDoorId {
    if ([_label.text isEqualToString:@""]) {
        [self showErrorWithTitle:@"Oops!" message0:@"You did not" message1:@"scan a door!" andWide:NO];
    } else {
        [self createLoadingViewWithMessage:@"loading..."];
        [[DSData defaultData] submitRequestToDoorId:_label.text withCompletionBlock:^(PFObject *response, NSError *error){
            [self removeLoadingView];
            if (!error) {
                NSLog(@"response: %@", response);
                NSString *lockedUnlockedString;
                if ([response[@"unlocked"] boolValue]) {
                    lockedUnlockedString = @"now unlocked.";
                } else {
                    lockedUnlockedString = @"now locked.";
                }
                [self showErrorWithTitle:@"Success!" message0:[NSString stringWithFormat:@"%@ is", response[@"doorName"]] message1:lockedUnlockedString andWide:NO];
                
            } else {
                if (error.code == 37) {
                    [self showErrorWithTitle:@"Sorry!" message0:@"You do not have permission" message1:@"to use this door." andWide:YES];
                } else if (error.code == 41) {
                    [self showErrorWithTitle:@"Oops!" message0:@"That is not a" message1:@"registered door." andWide:NO];
                } else {
                    [self showErrorWithTitle:@"Oops!" message0:@"Something went" message1:@"wrong." andWide:NO];
                }
                
                NSLog(@"error: %@", error);
            }
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


#pragma mark misc.
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

@end
