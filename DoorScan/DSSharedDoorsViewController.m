//
//  DSSharedDoorsViewController.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSSharedDoorsViewController.h"

@implementation DSSharedDoorsViewController

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
    
    sharedDoorsData = [[NSMutableArray alloc] init];
    
    headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.view.frame.size.width, 50)];
    headerTitleLabel.text = @"Shared Doors";
    headerTitleLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:31];
    headerTitleLabel.textColor = [UIColor whiteColor];
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerTitleLabel];

    sharedDoorsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerView.frame.size.height - 49) style:UITableViewStylePlain];
    sharedDoorsTable.scrollEnabled = YES;
    sharedDoorsTable.bounces = YES;
    sharedDoorsTable.userInteractionEnabled = YES;
    sharedDoorsTable.backgroundColor = [UIColor whiteColor];
    sharedDoorsTable.delegate = self;
    sharedDoorsTable.dataSource = self;
    if ([sharedDoorsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [sharedDoorsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:sharedDoorsTable];
    
    sharedDoorsRefreshControl = [[UIRefreshControl alloc] init];
    [sharedDoorsRefreshControl addTarget:self action:@selector(refreshSharedDoors) forControlEvents:UIControlEventValueChanged];
    [sharedDoorsTable addSubview:sharedDoorsRefreshControl];
    
    [self refreshSharedDoors];
}

- (void) refreshSharedDoors {
    [[DSData defaultData] getSharedDoorsWithCompletionBlock:^(NSMutableArray *results, NSError *error){
        [sharedDoorsRefreshControl endRefreshing];
        if (!error) {
            sharedDoorsData = results;
            [sharedDoorsTable reloadData];
        }
    }];
}

#pragma mark TableView Delegate Methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sharedDoorsData.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    sharedDoorsCell *cell = [sharedDoorsTable dequeueReusableCellWithIdentifier:@"sharedDoorsTableCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[sharedDoorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sharedDoorsTableCell"];
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSMutableDictionary *curDict = [sharedDoorsData objectAtIndex:indexPath.row];
    PFObject *curDoor = [curDict objectForKey:@"door"];
    PFUser *curAdmin = [curDict objectForKey:@"user"];
    cell.doorNameLabel.text = curDoor[@"doorName"];
    cell.userNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", curAdmin[@"name"], curAdmin.username];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sharedDoorsTable deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark misc.
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

@end
