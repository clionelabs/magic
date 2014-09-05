//
//  LPViewController.h
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPViewController : UIViewController <UIAlertViewDelegate>

- (void)updateLocaiton:(NSDictionary *)location;
- (IBAction)changeTitle:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpleLabel;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *purpleButton;

@end
