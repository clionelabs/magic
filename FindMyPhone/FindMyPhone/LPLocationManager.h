//
//  LPLocationManager.h
//  FindMyPhone
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LPLocationManager : CLLocationManager <CLLocationManagerDelegate>
- (id)init;
@end
