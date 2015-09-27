//
//  DSMyDoorsViewController.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSMyDoorsViewController.h"

@implementation DSMyDoorsViewController

- (id) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) viewDidLoad {
    isInBase = YES;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor myGreenTheme2];
    [self.view addSubview:headerView];
    
    headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.view.frame.size.width, 50)];
    headerTitleLabel.text = @"My Doors";
    headerTitleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:31];
    headerTitleLabel.textColor = [UIColor whiteColor];
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerTitleLabel];
    
    myDoorsData = [[NSMutableArray alloc] init];
    
    myDoorsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49) style:UITableViewStylePlain];
    myDoorsTable.scrollEnabled = YES;
    myDoorsTable.bounces = YES;
    myDoorsTable.userInteractionEnabled = YES;
    myDoorsTable.backgroundColor = [UIColor whiteColor];
    myDoorsTable.delegate = self;
    myDoorsTable.dataSource = self;
    if ([myDoorsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myDoorsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:myDoorsTable];
    
    myDoorsRefreshControl = [[UIRefreshControl alloc] init];
    [myDoorsRefreshControl addTarget:self action:@selector(refreshMyDoorsTable) forControlEvents:UIControlEventValueChanged];
    [myDoorsTable addSubview:myDoorsRefreshControl];

    backButton = [self createStandardButtonWithImage:@"smallBack"
                                         andSelector:@selector(popTop)
                                          withTarget:self
                                          atPosition:CGPointMake(9, 28)];
    
    doorStatusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 30, 21, 29)];
    
    doorStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 30, 21, 29)];
    
    [myDoorsRefreshControl beginRefreshing];
    [self refreshMyDoorsTable];
    
    
}

- (void) refreshMyDoorsTable {
    [[DSData defaultData] getMyDoorsWithCompletionBlock:^(NSMutableArray *results, NSError *error) {
        [myDoorsRefreshControl endRefreshing];
        if (!error) {
            myDoorsData = results;
            [myDoorsTable reloadData];
        }
    }];
}

#pragma mark TableView Delegate Methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableHeightForRowAtIndexPath:indexPath];
    } else if (tableView == myDoorView.sharedWithTable) {
        return [self sharedWithTableHeightForRowAtIndexPath:indexPath];
    } else if (tableView == myAddUsersView.mySearchTable) {
        return [self searchTableHeightForRowAtIndexPath:indexPath];
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableNumberOfRowsInSection:section];
    } else if (tableView == myDoorView.sharedWithTable) {
        return [self sharedWithTableNumberOfRowsInSection:section];
    } else if (tableView == myAddUsersView.mySearchTable) {
        return [self searchTableNumberOfRowsInSection:section];
    } else {
        return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableCellForRowAtIndexPath:indexPath];
    } else if (tableView == myDoorView.sharedWithTable) {
        return [self sharedWithTableCellForRowAtIndexPath:indexPath];
    } else if (tableView == myAddUsersView.mySearchTable) {
        return [self searchTableCellForRowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        [self myDoorsTableDidSelectRowAtIndexPath:indexPath];
    } else if (tableView == myDoorView.sharedWithTable) {
        [self sharedWithTableDidSelectRowAtIndexPath:indexPath];
    } else if (tableView == myAddUsersView.mySearchTable) {
        [self searchTableDidSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark myDoorsTable delegates
- (CGFloat) myDoorsTableHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger) myDoorsTableNumberOfRowsInSection:(NSInteger)section {
    return myDoorsData.count;
}

- (UITableViewCell*) myDoorsTableCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myDoorsCell *cell = [myDoorsTable dequeueReusableCellWithIdentifier:@"myDoorsTableCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[myDoorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myDoorsTableCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    PFObject *curDoor = [myDoorsData objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", curDoor[@"doorName"]];
    [cell setLocked:![curDoor[@"unlocked"] boolValue]];
    
    [cell.rightImage removeFromSuperview];
    cell.nameLabel.frame = CGRectMake(20, 0, self.view.frame.size.width - 20, 55);
    cell.leftImage.center = CGPointMake(40, 29);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

- (void) myDoorsTableDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isInBase = NO;
    PFObject *curDoor = [myDoorsData objectAtIndex:indexPath.row];
    headerTitleLabel.text = curDoor[@"doorName"];
    [self.view addSubview:backButton];
    
    myDoorView = [[DSDoorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0) andData:curDoor  andDelegate:self];
    [self.view addSubview:myDoorView];
    
    [doorStatusButton addTarget:self action:@selector(unlockLockClicked) forControlEvents:UIControlEventTouchUpInside];
    doorStatusButton.alpha = 0.0;
    
    if ([curDoor[@"unlocked"] boolValue]) {
        myDoorView.shareButton.tintColor = [UIColor myGreenTheme2];
        doorStatusIcon.image = [[UIImage imageNamed:@"unlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [doorStatusButton setImage:doorStatusIcon.image forState:UIControlStateNormal];
        doorStatusButton.imageView.tintColor = [UIColor whiteColor];
    } else {
        headerView.backgroundColor = [UIColor myDarkRedColor];
        headerTitleLabel.backgroundColor = [UIColor myDarkRedColor];
        myDoorView.shareButton.tintColor = [UIColor myDarkRedColor];
        doorStatusIcon.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [doorStatusButton setImage:doorStatusIcon.image forState:UIControlStateNormal];
        doorStatusButton.imageView.tintColor = [UIColor whiteColor];
    }
    [headerView addSubview:doorStatusButton];
    
    [myDoorsTable deselectRowAtIndexPath:indexPath animated:YES];
    
    myDoorView.sharedWithTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, self.view.frame.size.width, myDoorView.frame.size.height - 41) style:UITableViewStylePlain];
    myDoorView.sharedWithTable.scrollEnabled = YES;
    myDoorView.sharedWithTable.bounces = YES;
    myDoorView.sharedWithTable.userInteractionEnabled = YES;
    myDoorView.sharedWithTable.separatorColor = [UIColor myGrayThemeColor];
    myDoorView.sharedWithTable.backgroundColor = [UIColor whiteColor];
    myDoorView.sharedWithTable.delegate = self;
    myDoorView.sharedWithTable.dataSource = self;
    if ([myDoorView.sharedWithTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myDoorView.sharedWithTable setSeparatorInset:UIEdgeInsetsZero];
    }
    myDoorView.sharedWithTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [myDoorView addSubview:myDoorView.sharedWithTable];
    
    myDoorView.shareButton.tag = indexPath.row;
    [myDoorView.shareButton addTarget:self action:@selector(addUsersScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    myDoorView.sharedWithRefresh = [[UIRefreshControl alloc] init];
    [myDoorView.sharedWithRefresh addTarget:self action:@selector(refreshSharedWithTable) forControlEvents:UIControlEventValueChanged];
    [myDoorView.sharedWithTable addSubview:myDoorView.sharedWithRefresh];
    
    [myDoorView.sharedWithRefresh beginRefreshing];
    [myDoorView.sharedWithTable scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
    [self refreshSharedWithTable];
    
    [UIView animateWithDuration:0.4 animations:^(void){
        myDoorView.frame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        myDoorsTable.frame = CGRectMake(-1 * self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        doorStatusButton.alpha = 1.0;
    }];
    
}

- (void) unlockLockClicked {
    if (!isLoading) {
        isLoading = YES;
        [self createLoadingViewWithMessage:@"loading..."];
        [myDoorView lockUnlockDoorWithCompletionBlock:^(NSError *error) {
            isLoading = NO;
            if (!isInBase) {
                if (!error) {
                    [self removeLoadingView];
                    
                    if (myDoorView.doorData) {
                        for (int i = 0; i < myDoorsData.count; i++) {
                            PFObject *curDoorData = [myDoorsData objectAtIndex:i];
                            if ([curDoorData.objectId isEqualToString:myDoorView.doorData.objectId]) {
                                [myDoorsData replaceObjectAtIndex:i withObject:myDoorView.doorData];
                            }
                        }
                        [myDoorsTable reloadData];
                        
                        if ([myDoorView.doorData[@"unlocked"] boolValue]) {
                            doorStatusIcon.image = [[UIImage imageNamed:@"unlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            [doorStatusButton setImage:doorStatusIcon.image forState:UIControlStateNormal];
                            doorStatusButton.imageView.tintColor = [UIColor whiteColor];
                            headerView.backgroundColor = [UIColor myGreenTheme2];
                            headerTitleLabel.backgroundColor = [UIColor myGreenTheme2];
                            myDoorView.shareButton.tintColor = [UIColor myGreenTheme2];
                            if (myAddUsersView) {
                                [myAddUsersView setSearchColorsToGreen:YES];
                            }
                        } else {
                            doorStatusIcon.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            [doorStatusButton setImage:doorStatusIcon.image forState:UIControlStateNormal];
                            doorStatusButton.imageView.tintColor = [UIColor whiteColor];
                            headerView.backgroundColor = [UIColor myDarkRedColor];
                            headerTitleLabel.backgroundColor = [UIColor myDarkRedColor];
                            myDoorView.shareButton.tintColor = [UIColor myDarkRedColor];
                            if (myAddUsersView) {
                                [myAddUsersView setSearchColorsToGreen:NO];
                            }
                        }
                    }
                    
                } else {
                    [self showErrorWithTitle:@"Oops!" message0:@"Something went" message1:@"wrong." andWide:NO];
                }
            }
        }];
    }
}

- (void) addUsersScreen:(id)sender {
    UIButton *senderButton = (UIButton*)sender;
    PFObject *curDoor = [myDoorsData objectAtIndex:senderButton.tag];
    myAddUsersView = [[DSAddUserView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0) andData: curDoor];
    [myAddUsersView.cancelSearchButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    myAddUsersView.searchField.delegate = self;
    
    myAddUsersView.mySearchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, myAddUsersView.frame.size.height - 40) style:UITableViewStylePlain];
    myAddUsersView.mySearchTable.scrollEnabled = YES;
    myAddUsersView.mySearchTable.bounces = YES;
    myAddUsersView.mySearchTable.userInteractionEnabled = YES;
    myAddUsersView.mySearchTable.separatorColor = [UIColor myGrayThemeColor];
    myAddUsersView.mySearchTable.backgroundColor = [UIColor whiteColor];
    myAddUsersView.mySearchTable.delegate = self;
    myAddUsersView.mySearchTable.dataSource = self;
    if ([myAddUsersView.mySearchTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myAddUsersView.mySearchTable setSeparatorInset:UIEdgeInsetsZero];
    }
    myAddUsersView.mySearchTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [myAddUsersView addSubview:myAddUsersView.mySearchTable];
    
    myAddUsersView.mySearchRefresh = [[UIRefreshControl alloc] init];
    
    [self.view addSubview:myAddUsersView];
    
    if ([curDoor[@"unlocked"] boolValue]) {
        [myAddUsersView setSearchColorsToGreen:YES];
    } else {
        [myAddUsersView setSearchColorsToGreen:NO];
    }
    
    [UIView animateWithDuration:0.4 animations:^(void) {
        myAddUsersView.frame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
    }];
}

- (void) cancelSearch {
    [myAddUsersView.searchField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        myAddUsersView.cancelSearchButton.alpha = 0.0;
        myAddUsersView.searchField.frame = myAddUsersView.origSearchFieldF;
    }];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        myAddUsersView.cancelSearchButton.alpha = 1.0;
        myAddUsersView.searchField.frame = CGRectMake(myAddUsersView.origSearchFieldF.origin.x, myAddUsersView.origSearchFieldF.origin.y, myAddUsersView.origSearchFieldF.size.width - 50, myAddUsersView.origSearchFieldF.size.height);
    }];
}

- (void) refreshSharedWithTable {
    [[DSData defaultData] getSharedWithDataForDoor:myDoorView.doorData withCompletionBlock:^(NSMutableArray *results, NSError *error) {
        if (!error) {
            myDoorView.sharedWithData = results;
            [myDoorView.sharedWithTable reloadData];
            [myDoorView.sharedWithRefresh endRefreshing];
            
        } else {
            NSLog(@"error: %@", error);
            // do nothing
        }
        
    }];
}


#pragma mark shared with delegates
- (CGFloat) sharedWithTableHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger) sharedWithTableNumberOfRowsInSection:(NSInteger)section {
    return myDoorView.sharedWithData.count;
}

- (UITableViewCell*) sharedWithTableCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    sharedWithCell *cell = [myDoorView.sharedWithTable dequeueReusableCellWithIdentifier:@"sharedWithCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[sharedWithCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sharedWithCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]]];
    cell.delegate = self;
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    
    PFObject *curPermission = [myDoorView.sharedWithData objectAtIndex:indexPath.row];
    
    cell.tag = indexPath.row;

    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", curPermission[@"usersName"], curPermission[@"usersUsername"]];
    cell.nameLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
    
    
    return cell;
}


- (void) sharedWithTableDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!myDoorView.sharedWithTable.isEditing) {
        [myDoorView.sharedWithTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL) swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    if ([cell isKindOfClass:[sharedWithCell class]]) {
        PFObject *curPermission = [myDoorView.sharedWithData objectAtIndex:cell.tag];
        [[DSData defaultData] deletePermissionEventually:curPermission];
        [myDoorView.sharedWithData removeObjectAtIndex:cell.tag];
        [myDoorView.sharedWithTable reloadData];
        
    } else {
        
        
    }
    return YES;
}

#pragma mark search table delegate
- (CGFloat) searchTableHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger) searchTableNumberOfRowsInSection:(NSInteger)section {
    return myAddUsersView.mySearchData.count;
}

- (UITableViewCell*) searchTableCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    searchCell *cell = [myAddUsersView.mySearchTable dequeueReusableCellWithIdentifier:@"searchCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[searchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.delegate = self;
    
    cell.tag = indexPath.row;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor myGreenTheme4];
    cell.selectedBackgroundView = selectionColor;

    NSMutableDictionary *curDict = [myAddUsersView.mySearchData objectAtIndex:indexPath.row];
    PFUser *curUser = [curDict objectForKey:@"user"];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", curUser[@"name"], curUser.username];
    
    if ([curDict objectForKey:@"permission"] == [NSNull null]) {
        // Because Melissa said don't do this!
        /*
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Add" backgroundColor:[UIColor myGreenTheme4]]];
        cell.rightSwipeSettings.transition = MGSwipeTransitionClipCenter;
         */
        cell.permissionImage.image = [[UIImage imageNamed:@"hasNoPermission"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.permissionImage.tintColor = [UIColor myRedThemeColor];
        
    } else {
        cell.permissionImage.image = [[UIImage imageNamed:@"hasPermission"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.permissionImage.tintColor = [UIColor myGreenTheme2];

    }
    
    return cell;
}


- (void) searchTableDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!myAddUsersView.mySearchTable.isEditing) {
        
        NSMutableDictionary *curDict = [myAddUsersView.mySearchData objectAtIndex:indexPath.row];
        PFUser *curUser = [curDict objectForKey:@"user"];
        PFObject *curDoor = myAddUsersView.doorData;
        PFObject *newPermission = [[DSData defaultData] createPermissionForUser:curUser andDoor:curDoor];
        [curDict setObject:newPermission forKey:@"permission"];
        
        [myAddUsersView.mySearchTable reloadData];
        
        [myDoorView.sharedWithData addObject:newPermission];
        [myDoorView.sharedWithTable reloadData];
        
        [myAddUsersView.mySearchTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        
        [myAddUsersView.searchField resignFirstResponder];
        [self showSearchRefresh:YES];
        
        [[DSData defaultData] findUsersForString:textField.text withDoor:myAddUsersView.doorData.objectId withCompletionBlock:^(NSMutableArray *results, NSError *error){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                [self showSearchRefresh:NO];
                if (!error) {
                    NSLog(@"results: %@", results);
                    myAddUsersView.mySearchData = results;
                    [myAddUsersView.mySearchTable reloadData];
                    
                } else {
                    NSLog(@"error: %@", error);
                }
            }];
            
        }];
    }
    
    return YES;
}

- (void) showSearchRefresh:(BOOL)shouldShow {
    if (shouldShow) {
        [myAddUsersView.mySearchTable addSubview:myAddUsersView.mySearchRefresh];
        [myAddUsersView.mySearchRefresh beginRefreshing];
        [myAddUsersView.mySearchTable scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
    } else {
        [myAddUsersView.mySearchRefresh endRefreshing];
        [myAddUsersView.mySearchRefresh removeFromSuperview];
    }
}

#pragma mark pop
- (void) popTop {
    if (myAddUsersView) {
        [UIView animateWithDuration:0.4 animations:^(void) {
            myAddUsersView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
            
        } completion:^(BOOL finished){
            [myAddUsersView removeFromSuperview];
            myAddUsersView = nil;
        }];
        
    } else {
        [self popViewingDoor];
    }
}

- (void) popViewingDoor {
    isInBase = YES;
    headerTitleLabel.text = @"My Doors";
    headerTitleLabel.backgroundColor = [UIColor myGreenTheme2];
    headerView.backgroundColor = [UIColor myGreenTheme2];
    [backButton removeFromSuperview];
    [doorStatusButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    if (loadingView) {
        [self removeLoadingView];
    }
    
    [UIView animateWithDuration:0.4 animations:^(void){
        myDoorView.frame = CGRectMake(self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        myDoorsTable.frame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        doorStatusButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [myDoorView removeFromSuperview];
        [doorStatusButton removeFromSuperview];

    }];
    
}

#pragma mark loading view
- (void) createLoadingViewWithMessage:(NSString*)message {
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height)];
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

- (UIButton*) createStandardButtonWithImage: (NSString*)imageName andSelector: (SEL)mySelector withTarget:(id)myTarget atPosition: (CGPoint)myPoint  {
    UIImage *myButtonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(myPoint.x, myPoint.y, 65.0, 35.0)];
    [button addTarget: myTarget
               action:mySelector
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:myButtonImage forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    
    /*
    button.layer.cornerRadius = 10;
    button.layer.borderColor=[UIColor myGrayThemeColor].CGColor;
    button.layer.borderWidth=2.0f;
    */
    return button;
}

@end
