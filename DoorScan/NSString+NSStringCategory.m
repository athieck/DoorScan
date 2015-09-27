//
//  NSString+NSStringCategory.m
//  DoorScan
//
//  Created by Andrew Thieck on 9/25/15.
//  Copyright (c) 2015 Andrew Thieck. All rights reserved.
//

#import "NSString+NSStringCategory.h"

@implementation NSString (NSStringCategory)

- (NSDictionary *) json_StringToDictionary {
    NSError *error;
    NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
    return (error ? nil : json);
}

@end
