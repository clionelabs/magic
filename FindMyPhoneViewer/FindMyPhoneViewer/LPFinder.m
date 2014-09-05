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

@interface LPFinder ()
@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic) NSMutableArray *buffer;
@end

@implementation LPFinder
- (id)init
{
    self = [super init];
    if (self) {
        NSString *url = @"https://looppulse-dev-thomas.firebaseio.com";
        self.buffer = [[NSMutableArray alloc] init];
        self.firebase = [[Firebase alloc] initWithUrl:url];
        [self observeFirebase];
    }
    return self;
}

- (void)observeFirebase
{
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        [self.buffer push:snapshot.value];
        [snapshot.ref removeValue];
    }];
}

- (NSDictionary *)location
{
    return [NSDictionary dictionary];
}

@end
