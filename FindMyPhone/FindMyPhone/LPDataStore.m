//
//  LPDataStore.m
//  FindMyPhone
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "LPDataStore.h"
#import <Firebase/Firebase.h>
#import "CLBeacon+FirebaseDictionary.h"
#import "CLBeaconRegion+FirebaseDictionary.h"

@interface LPDataStore ()
@property (nonatomic, strong) Firebase *firebase;
@end

@implementation LPDataStore
- (id)init
{
    self = [super init];
    if (self) {
        NSString *url = @"https://looppulse-dev-thomas.firebaseio.com";
        self.firebase = [[Firebase alloc] initWithUrl:url];
    }
    return self;
}

- (NSNumber *)priority
{
    NSDate *now = [NSDate date];
    return @(now.timeIntervalSince1970);
}

- (void)logEvent:(NSString *)eventType withBeacon:(CLBeacon *)beacon atTime:(NSDate *)createdAt
{
    [self logEvent:eventType
    withDictionary:[beacon firebaseDictionary]
            atTime:createdAt];
}

- (void)logEvent:(NSString *)eventType withBeaconRegion:(CLBeaconRegion *)region atTime:(NSDate *)createdAt
{
    [self logEvent:eventType
    withDictionary:[region firebaseDictionary]
            atTime:createdAt];
}

- (void)logEvent:(NSString *)eventType withDictionary:(NSDictionary *)beaconInfo atTime:(NSDate *)createdAt
{
    NSNumber *priority = @([createdAt timeIntervalSince1970]);
    NSDictionary *eventInfo = @{@"type": eventType,
                                @"created_at": [createdAt description]};
    NSMutableDictionary *beaconInfoAndEvent = [[NSMutableDictionary alloc] initWithDictionary:beaconInfo];
    [beaconInfoAndEvent addEntriesFromDictionary:eventInfo];

    Firebase *ref = [self.firebase childByAutoId];
    [ref setValue:beaconInfoAndEvent andPriority:priority];
}

@end
