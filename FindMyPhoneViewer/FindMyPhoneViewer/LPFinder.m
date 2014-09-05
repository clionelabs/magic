//
//  LPFinder.m
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "LPFinder.h"
#import <Firebase/Firebase.h>
#import "NSMutableArray+Queue.h"
#import <CoreLocation/CoreLocation.h>

#import "LPAppDelegate.h"
#import "LPViewController.h"

@interface LPFinder ()
@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic) NSMutableArray *buffer;
@property (nonatomic, readonly) NSArray *beaconRegions;
@end

@implementation LPFinder
@synthesize beaconRegions=_beaconRegions;
@synthesize location=_location;

- (id)init
{
    self = [super init];
    if (self) {
        _location = [NSDictionary dictionary];
        NSString *url = @"https://looppulse-dev-thomas.firebaseio.com";
        self.buffer = [[NSMutableArray alloc] init];
        self.firebase = [[Firebase alloc] initWithUrl:url];
        [self observeFirebase];
    }
    return self;
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

- (void)observeFirebase
{
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self processEvent:snapshot];
    }];
}

- (void)processEvent:(FDataSnapshot *)snapshot
{
    // use last didEnterRegion event
    NSDictionary *event = snapshot.value;
    NSString *type = [event objectForKey:@"type"];
    if ([type isEqualToString: @"didEnterRegion"] ||
        [type isEqualToString: @"didExitRegion"]) {
        NSString *identifier = [event objectForKey:@"identifier"];
        [self updateLocation:identifier forType:type];
    }

    [self.buffer push:snapshot.value];
    [snapshot.ref removeValue];
}

- (void)updateLocation:(NSString *)newLocationIdentifier forType:(NSString *)type
{
    _location = @{newLocationIdentifier: type};
    NSLog(@"Location: %@", self.location);

    [self updateUI];
}

- (void)updateUI
{
    // Hacky way to update UI.
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    LPViewController *lpVC = (LPViewController *)rootVC;
    [lpVC updateLocaiton:self.location];
}

@end
