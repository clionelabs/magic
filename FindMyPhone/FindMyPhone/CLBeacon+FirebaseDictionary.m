//
//  CLBeacon+FirebaseDictionary.m
//  LightHouse
//
//  Created by Thomas Pun on 5/3/14.
//  Copyright (c) 2014 Clione Labs. All rights reserved.
//

#import "CLBeacon+FirebaseDictionary.h"

@implementation CLBeacon (FirebaseDictionary)

- (NSDictionary *)firebaseDictionary
{
    NSDictionary *const CLProximityToNSString = @{@(CLProximityUnknown).stringValue: @"unknown",
                                                  @(CLProximityFar).stringValue: @"far",
                                                  @(CLProximityNear).stringValue: @"near",
                                                  @(CLProximityImmediate).stringValue: @"immediate"};
//    CLBeaconRegion *blue  = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1901 minor:12001 identifier:@"blue"];
//    CLBeaconRegion *green = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:214  minor:2104  identifier:@"green"];
//    CLBeaconRegion *purple= [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1213 minor:14001 identifier:@"purple"];
    NSString *identifier = [NSString string];
    if ([self.major integerValue]==1901) {
        identifier = @"blue";
    } else if ([self.major integerValue]==214) {
        identifier = @"green";
    } else if ([self.major integerValue]==1213) {
        identifier = @"purple";
    }

    return @{@"uuid": [self.proximityUUID UUIDString],
             @"major": self.major,
             @"minor": self.minor,
             @"proximity": CLProximityToNSString[@(self.proximity).stringValue],
             @"accuracy": @(self.accuracy),
             @"rssi": @(self.rssi),
             @"identifier": identifier};
}
@end
