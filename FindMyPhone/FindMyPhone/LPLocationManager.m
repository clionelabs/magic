//
//  LPLocationManager.m
//  FindMyPhone
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "LPLocationManager.h"
#import "LPDataStore.h"
@interface LPLocationManager ()
@property (readonly, nonatomic) NSArray *beaconRegions;
@property (nonatomic, strong) LPDataStore *dataStore;
@end

@implementation LPLocationManager
@synthesize beaconRegions=_beaconRegions;

- (id)init
{
    self = [super init];
    if (self) {
        self.dataStore = [[LPDataStore alloc] init];

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

    [self startRanging];
    NSLog(@"startRanging: %@", self.rangedRegions);
}

- (void)startRanging
{
    // Only range the generic one.
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A2DCA1E4-0607-4F37-9FF1-825237B278FE"];
    CLBeaconRegion *generic = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"generic"];
    [self startRangingBeaconsInRegion:generic];
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

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"didEnterRegion: %@", beaconRegion);

    [self.dataStore logEvent:@"didEnterRegion" withBeaconRegion:beaconRegion atTime:[NSDate date]];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"didExitRegion: %@", beaconRegion);

    [self.dataStore logEvent:@"didExitRegion" withBeaconRegion:beaconRegion atTime:[NSDate date]];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // Sort the beacons by proximity first and then accuracy.
    NSArray *filteredBeacons = beacons;
    filteredBeacons = [self filterByKnownProximities:beacons];
    NSArray *sorted = [self sortedByAccuracy:filteredBeacons];

    if (sorted.count > 0) {
        NSLog(@"didRangeBeacons: %@", [sorted firstObject]);
        [self.dataStore logEvent:@"didRangeBeacons" withBeacon:[sorted firstObject] atTime:[NSDate date]];
    }
}

- (NSArray *)filterByKnownProximities:(NSArray *)beacons
{
    // Don't send anything "far"
    NSArray *knownProximities = @[@(CLProximityImmediate), @(CLProximityNear)];
    NSPredicate *knownProximityPredicate = [NSPredicate predicateWithFormat:@"proximity IN %@", knownProximities];
    NSPredicate *nonNegativeAccuracyPredicate = [NSPredicate predicateWithFormat:@"accuracy >= 0"];
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[knownProximityPredicate, nonNegativeAccuracyPredicate]];
    return [beacons filteredArrayUsingPredicate:andPredicate];
}

- (NSArray *)sortedByAccuracy:(NSArray *)beacons
{
    // Most accurate to least
    return [beacons sortedArrayUsingComparator:^NSComparisonResult(CLBeacon *b1, CLBeacon *b2){
        return (b1.accuracy > b2.accuracy);
    }];
}

@end
