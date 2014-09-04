//
//  LPLocationManager.m
//  FindMyPhone
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "LPLocationManager.h"

@interface LPLocationManager ()
@property (readonly, nonatomic) NSArray *beaconRegions;
@end

@implementation LPLocationManager
@synthesize beaconRegions=_beaconRegions;

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        [self startMonitoringAndRanging];
    }
    return self;
}

- (void)startMonitoringAndRanging
{
    for (CLBeaconRegion *region in self.beaconRegions) {
        if (![self.monitoredRegions containsObject:region]) {
            [self startMonitoringForRegion:region];
        }
    }
    NSLog(@"startMonitoring: %@", self.monitoredRegions);

    for (CLBeaconRegion *region in self.beaconRegions) {
        if (![self.rangedRegions containsObject:region]) {
            [self startRangingBeaconsInRegion:region];
        }
    }
    NSLog(@"startRanging: %@", self.rangedRegions);
}

- (NSArray *)beaconRegions
{
    if (!_beaconRegions) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A2DCA1E4-0607-4F37-9FF1-825237B278FE"];

        CLBeaconRegion *blue  = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1901 minor:12001 identifier:@"blue"];
        CLBeaconRegion *green = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:214  minor:2104  identifier:@"green"];
        CLBeaconRegion *purple= [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1213 minor:14001 identifier:@"purple"];

        _beaconRegions = [[NSArray alloc] initWithObjects:blue, green, purple, nil];
    }
    return _beaconRegions;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state==CLRegionStateInside) {
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"didEnterRegion: %@", beaconRegion);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"didExitRegion: %@", beaconRegion);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *filteredBeacons = beacons;
    filteredBeacons = [self filterByKnownProximities:beacons];

    for (CLBeacon *beacon in filteredBeacons) {
        NSLog(@"didRangeBeacons: %@", beacon);
    }
}

- (NSArray *)filterByKnownProximities:(NSArray *)beacons
{
    NSArray *knownProximities = @[@(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)];
    NSPredicate *knownProximityPredicate = [NSPredicate predicateWithFormat:@"proximity IN %@", knownProximities];
    return [beacons filteredArrayUsingPredicate:knownProximityPredicate];
}

@end
