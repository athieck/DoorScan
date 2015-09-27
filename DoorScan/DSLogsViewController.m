//
//  DSLogsViewController.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSLogsViewController.h"

@implementation DSLogsViewController

- (id) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) viewDidLoad {
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor myGreenTheme2];
    [self.view addSubview:headerView];
    
    headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.view.frame.size.width, 50)];
    headerTitleLabel.text = @"Logs";
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
                                          atPosition:CGPointMake(14, 27)];
    
    [self refreshMyDoorsTable];
    
}

- (void) refreshMyDoorsTable {
    [[DSData defaultData] getMyDoorsWithCompletionBlock:^(NSMutableArray *results, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            [myDoorsRefreshControl endRefreshing];
            if (!error) {
                myDoorsData = results;
                [myDoorsTable reloadData];
            }
            
        }];
    }];
}

#pragma mark TableView Delegate Methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableHeightForRowAtIndexPath:indexPath];
    } else if (tableView == myDoorLogView.logTable) {
        return [self logTableHeightForRowAtIndexPath:indexPath];
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableNumberOfRowsInSection:section];
    } else if (tableView == myDoorLogView.logTable) {
        return [self logTableNumberOfRowsInSection:section];
    } else {
        return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        return [self myDoorsTableCellForRowAtIndexPath:indexPath];
    } else if (tableView == myDoorLogView.logTable) {
        return [self logTableCellForRowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myDoorsTable) {
        [self myDoorsTableDidSelectRowAtIndexPath:indexPath];
    } else {
        [self logTableDidSelectRowAtIndexPath:indexPath];
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
    sharedDoorsCell *cell = [myDoorsTable dequeueReusableCellWithIdentifier:@"myDoorsTableCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[sharedDoorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myDoorsTableCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    PFObject *curDoor = [myDoorsData objectAtIndex:indexPath.row];
    //cell.nameLabel.text = [NSString stringWithFormat:@"%@", curDoor[@"doorName"]];
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@", curDoor[@"doorName"]];
    cell.doorNameLabel.text = curDoor.updatedAt.timeAgoSinceNow;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}

- (void) myDoorsTableDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *curDoor = [myDoorsData objectAtIndex:indexPath.row];
    headerTitleLabel.text = curDoor[@"doorName"];
    [self.view addSubview:backButton];
    
    myDoorLogView = [[DSDoorLogView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0) andData:curDoor];
    [self.view addSubview:myDoorLogView];
    
    [myDoorsTable deselectRowAtIndexPath:indexPath animated:YES];
    
    myDoorLogView.logTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, myDoorLogView.frame.size.height) style:UITableViewStylePlain];
    myDoorLogView.logTable.scrollEnabled = YES;
    myDoorLogView.logTable.bounces = YES;
    myDoorLogView.logTable.userInteractionEnabled = YES;
    myDoorLogView.logTable.separatorColor = [UIColor myGrayThemeColor];
    myDoorLogView.logTable.backgroundColor = [UIColor whiteColor];
    myDoorLogView.logTable.delegate = self;
    myDoorLogView.logTable.dataSource = self;
    if ([myDoorLogView.logTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myDoorLogView.logTable setSeparatorInset:UIEdgeInsetsZero];
    }
    myDoorLogView.logTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [myDoorLogView addSubview:myDoorLogView.logTable];
    
    myDoorLogView.logRefresh = [[UIRefreshControl alloc] init];
    [myDoorLogView.logRefresh addTarget:self action:@selector(refreshLogTable) forControlEvents:UIControlEventValueChanged];
    [myDoorLogView.logTable addSubview:myDoorLogView.logRefresh];
    
    [myDoorLogView.logRefresh beginRefreshing];
    [myDoorLogView.logTable scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
    [self refreshLogTable];
    
    [UIView animateWithDuration:0.4 animations:^(void){
        myDoorLogView.frame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        myDoorsTable.frame = CGRectMake(-1 * self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
        
    }];
    
}

#pragma mark logTable delegates
- (CGFloat) logTableHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger) logTableNumberOfRowsInSection:(NSInteger)section {
    return myDoorLogView.logData.count;
}

- (UITableViewCell*) logTableCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    logCell *cell = [myDoorLogView.logTable dequeueReusableCellWithIdentifier:@"logCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[logCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSMutableDictionary *curDict = [myDoorLogView.logData objectAtIndex:indexPath.row];
    PFUser *curUser = [curDict objectForKey:@"user"];
    PFObject *curLog = [curDict objectForKey:@"log"];
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", curUser[@"name"], curUser.username];

    if ([curLog[@"unlocked"] boolValue]) {
        cell.statusImage.image = [[UIImage imageNamed:@"unlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.statusImage.tintColor = [UIColor myGreenTheme3];

    } else {
        cell.statusImage.image = [[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.statusImage.tintColor = [UIColor myRedThemeColor];
    }
    
    NSDate *logDate = curLog.createdAt;
    cell.timeStampLabel.text = logDate.timeAgoSinceNow;
    
    return cell;
}

- (void) logTableDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!myDoorLogView.logTable.isEditing) {
        [myDoorLogView.logTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void) refreshLogTable {
    [[DSData defaultData] getLogForDoor:myDoorLogView.doorData withCompletionBlock:^(NSMutableArray *results, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

        if (!error) {
            NSLog(@"results: %@", results);
            myDoorLogView.logData = results;
            [myDoorLogView.logTable reloadData];
            [myDoorLogView.logRefresh endRefreshing];
        }
       
        }];
    }];
}

#pragma mark misc.
- (void) popTop {
    if (myDoorLogView) {
        headerTitleLabel.text = @"Logs";
        
        [UIView animateWithDuration:0.4 animations:^(void){
            myDoorLogView.frame = CGRectMake(self.view.frame.size.width, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
            myDoorsTable.frame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49.0);
            
        } completion:^(BOOL finished) {
            [myDoorLogView removeFromSuperview];
            [backButton removeFromSuperview];
        }];
    }
}

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
