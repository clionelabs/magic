//
//  LPViewController.h
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPViewController : UIViewController
- (void)updateLocaiton:(NSDictionary *)location;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpleLabel;
@end
