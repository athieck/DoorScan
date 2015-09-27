//
//  DSData.h
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "NSString+NSStringCategory.h"
#import "Constants.h"

@interface DSData : NSObject

+ (DSData *)defaultData;
- (void) submitRequestToDoorId:(NSString*)doorId withCompletionBlock:(void (^)(PFObject *response, NSError *error)) completionBlock;
- (void) getSharedWithDataForDoor:(PFObject*)door withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock;
- (void) getMyDoorsWithCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock;
- (void) deletePermissionEventually:(PFObject*)curPermission;
- (void) findUsersForString:(NSString*)searchString withDoor:(NSString*)doorId withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock;
- (PFObject*) createPermissionForUser:(PFUser*)curUser andDoor:(PFObject*)curDoor;
- (void) getSharedDoorsWithCompletionBlock: (void (^)(NSMutableArray *results, NSError *error)) completionBlock;
- (void) getLogForDoor:(PFObject*)door withCompletionBlock:(void (^)(NSMutableArray *results, NSError *error)) completionBlock;
- (void) logUserOutWithCompletionBlock: (void (^)(NSError *error)) completionBlock;
- (void) logUsername:(NSString*)username andPassword:(NSString*)password inWithCompletionBlock: (void (^)(NSError *error)) completionBlock;

@end
