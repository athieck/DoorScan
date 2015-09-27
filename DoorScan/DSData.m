//
//  DSData.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "DSData.h"

@implementation DSData
static DSData *instance = nil;

+ (DSData *)defaultData {
    if(instance == nil) {
        instance = [[DSData alloc] init];
        
    }
    return instance;
}

- (id)init {
    self = [super init];
        if (self) {
            // do any initial setup required
            
            
        }
    return self;
}

- (void) submitRequestToDoorId:(NSString*)doorId withCompletionBlock:(void (^)(PFObject *response, NSError *error)) completionBlock {

    [PFCloud callFunctionInBackground:@"fakePush2" withParameters:@{@"doorId":doorId} block:^(PFObject *response, NSError *error) {
        if (!error) {
            completionBlock(response, nil);

        } else {
            NSDictionary *subError = [[error.userInfo objectForKey:@"error"] json_StringToDictionary];
            
            if (subError && [subError objectForKey:@"code"] && [[subError objectForKey:@"code"] intValue] == 37) {
                NSError *newError = [NSError errorWithDomain:@"The person does not have permission" code:37 userInfo:@{}];
                completionBlock(nil, newError);
                
            } else if (subError && [subError objectForKey:@"code"] && [[subError objectForKey:@"code"] intValue] == 41) {
                NSError *newError = [NSError errorWithDomain:@"The person does not have permission" code:41 userInfo:@{}];
                completionBlock(nil, newError);
                
            } else {
                completionBlock(nil, error);
                
            }
        }
    }];
}

- (void) getMyDoorsWithCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock {
    
    PFQuery *doorsQuery = [PFQuery queryWithClassName:@"Door"];
    [doorsQuery whereKey:@"admin" equalTo:[PFUser currentUser].objectId];
    doorsQuery.limit = 100;
    [[doorsQuery findObjectsInBackground] continueWithBlock:^id(BFTask *task) {
        if (!task.error) {
            completionBlock(task.result, nil);
        } else {
            completionBlock(nil, task.error);
        }
        return nil;
    }];
}

- (void) getSharedWithDataForDoor:(PFObject*)door withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock {
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Permission"];
    [userQuery whereKey:@"doorId" equalTo:door.objectId];
    [userQuery orderByAscending:@"usersName"];
    [[userQuery findObjectsInBackground] continueWithBlock:^id(BFTask *task) {
        if (!task.error) {
            completionBlock(task.result, nil);
        } else {
            completionBlock(nil, task.error);
        }
        return nil;
    }];
    
}

- (void) deletePermissionEventually:(PFObject*)curPermission {
    [curPermission deleteEventually];
}

- (void) findUsersForString:(NSString*)searchString withDoor:(NSString*)doorId withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock {
    
    __block NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSString *lcSearch = [searchString lowercaseString];
    
    PFQuery *nameQuery = [PFUser query];
    [nameQuery whereKey:@"lcName" containsString:lcSearch];
    
    PFQuery *usernameQuery = [PFUser query];
    [usernameQuery whereKey:@"lcUsername" containsString:lcSearch];
    
    PFQuery *mainUserQuery = [PFQuery orQueryWithSubqueries:@[nameQuery, usernameQuery]];
    [mainUserQuery orderByAscending:@"name"];
    
    [[[[mainUserQuery findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        NSMutableArray *resultIds = [[NSMutableArray alloc] init];
        for (int i = 0; i < results.count; i++) {
            NSMutableDictionary *curDict = [[NSMutableDictionary alloc] init];
            [curDict setObject:[results objectAtIndex:i] forKey:@"user"];
            [returnArray addObject:curDict];
            
            PFUser *curUser = [results objectAtIndex:i];
            [resultIds addObject:curUser.objectId];
        }
        
        PFQuery *permissionsQuery = [PFQuery queryWithClassName:@"Permission"];
        [permissionsQuery whereKey:@"doorId" equalTo:doorId];
        [permissionsQuery whereKey:@"userId" containedIn:resultIds];
        return [permissionsQuery findObjectsInBackground];
        
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        for (int i = 0; i < returnArray.count; i++) {
            NSMutableDictionary *curDict = [returnArray objectAtIndex:i];
            PFUser *curUser = [curDict objectForKey:@"user"];
            
            BOOL hasFoundMatch = NO;
            for (int k = 0; k < results.count; k++) {
                PFObject *curPermission = [results objectAtIndex:k];
                if ([curUser.objectId isEqualToString:curPermission[@"userId"]]) {
                    hasFoundMatch = YES;
                    [curDict setObject:curPermission forKey:@"permission"];
                }
            }
            
            if (!hasFoundMatch) {
                [curDict setObject:[NSNull null] forKey:@"permission"];
            }
            
        }
        
        completionBlock(returnArray, nil);
        return nil;
        
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            completionBlock(nil, task.error);
        }
        return nil;
    }];
    
}

- (PFObject*) createPermissionForUser:(PFUser*)curUser andDoor:(PFObject*)curDoor {
    PFObject *newPermission = [PFObject objectWithClassName:@"Permission"];
    newPermission[@"userId"] = curUser.objectId;
    newPermission[@"doorId"] = curDoor.objectId;
    newPermission[@"usersUsername"] = curUser.username;
    newPermission[@"usersName"] = curUser[@"name"];
    [newPermission saveEventually];
    
    return newPermission;
}

- (void) getSharedDoorsWithCompletionBlock: (void (^)(NSMutableArray *results, NSError *error)) completionBlock {
    
    __block NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Permission"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    
    [[[[[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        NSMutableArray *doorIds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < results.count; i++) {
            NSMutableDictionary *curDict = [[NSMutableDictionary alloc] init];
            PFObject *curPermission = [results objectAtIndex:i];
            [curDict setObject:curPermission forKey:@"permission"];
            [retArray addObject:curDict];
            
            [doorIds addObject:curPermission[@"doorId"]];
        }
        
        PFQuery *doorQuery = [PFQuery queryWithClassName:@"Door"];
        [doorQuery whereKey:@"objectId" containedIn:doorIds];
        
        return [doorQuery findObjectsInBackground];
        
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        
        NSMutableArray *adminIds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < retArray.count; i++) {
            NSMutableDictionary *curDict = [retArray objectAtIndex:i];
            PFObject *curPermission = [curDict objectForKey:@"permission"];
            
            for (int k = 0; k < results.count; k++) {
                PFObject *curDoor = [results objectAtIndex:k];
                if ([curDoor.objectId isEqualToString:curPermission[@"doorId"]]) {
                    [curDict setObject:curDoor forKey:@"door"];
                    
                    [adminIds addObject:curDoor[@"admin"]];
                }
            }
        }
        
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"objectId" containedIn:adminIds];
        
        return [userQuery findObjectsInBackground];
        
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        
        for (int i = 0; i < retArray.count; i++) {
            NSMutableDictionary *curDict = [retArray objectAtIndex:i];
            PFObject *curDoor = [curDict objectForKey:@"door"];
            
            for (int k = 0; k < results.count; k++) {
                PFUser *curUser = [results objectAtIndex:k];
                if ([curUser.objectId isEqualToString:curDoor[@"admin"]]) {
                    [curDict setObject:curUser forKey:@"user"];
                }
                
            }
        }
        
        completionBlock(retArray, nil);
        
        return nil;
        
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            completionBlock(nil, task.error);
        }
        return nil;
    }];
    
}

- (void) getLogForDoor:(PFObject*)door withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock {
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    PFQuery *logQuery = [PFQuery queryWithClassName:@"Log"];
    [logQuery whereKey:@"doorId" equalTo:door.objectId];
    [logQuery orderByDescending:@"createdAt"];
    logQuery.limit = 100;
    
    [[[[logQuery findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        
        NSMutableArray *userIds = [[NSMutableArray alloc] init];
        for (int i = 0; i < results.count; i++) {
            NSMutableDictionary *curDict = [[NSMutableDictionary alloc] init];
            PFObject *curLog = [results objectAtIndex:i];
            [curDict setObject:curLog forKey:@"log"];
            [retArray addObject:curDict];
            
            [userIds addObject:curLog[@"userId"]];
            
        }
        
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"objectId" containedIn:userIds];
        
        
        return [userQuery findObjectsInBackground];
        
    }] continueWithSuccessBlock:^id(BFTask *task) {
        NSMutableArray *results = (NSMutableArray*)task.result;
        
        for (int i = 0; i < retArray.count; i++) {
            NSMutableDictionary *curDict = [retArray objectAtIndex:i];
            PFObject *curLog = [curDict objectForKey:@"log"];
            
            for (int k = 0; k < results.count; k++) {
                PFUser *curUser = [results objectAtIndex:k];
                if ([curLog[@"userId"] isEqualToString:curUser.objectId]) {
                    [curDict setObject:curUser forKey:@"user"];
                }
                
            }
            
        }
        
        completionBlock(retArray, nil);
        return nil;
        
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            completionBlock(nil, task.error);
        }
        return nil;
    }];
    
}

- (void) logUserOutWithCompletionBlock: (void (^)(NSError *error)) completionBlock {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:loginOrPassNotification object:self];
        }
        completionBlock(error);

    }];
}

- (void) logUsername:(NSString*)username andPassword:(NSString*)password inWithCompletionBlock: (void (^)(NSError *error)) completionBlock {
    [[PFUser logInWithUsernameInBackground:username password:password] continueWithBlock:^id(BFTask *task) {
        if (!task.error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:loginOrPassNotification object:self];
        } else {
            completionBlock(task.error);
        }
        
        return nil;
    }];
    
}

@end
