//
//  LPViewController.m
//  FindMyPhoneViewer
//
//  Created by Thomas Pun on 9/5/14.
//  Copyright (c) 2014 Loop Pulse. All rights reserved.
//

#import "LPViewController.h"

@interface LPViewController ()
@property (nonatomic, strong) NSDictionary *identifierToLabels;
@end

@implementation LPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.identifierToLabels = @{ @"blue": self.blueLabel,
                                 @"green": self.greenLabel,
                                 @"purple": self.purpleLabel};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLocaiton:(NSDictionary *)location
{
    NSString *identifier = [[location allKeys] firstObject];
    NSString *type = [location objectForKey:identifier];

    [self.identifierToLabels enumerateKeysAndObjectsUsingBlock:^(NSString *key, UILabel *label, BOOL *stop){
        if ([key isEqualToString:identifier]) {
            if ([type isEqualToString:@"didEnterRegion"]) {
                [label setAlpha:1.0];
                [label setHidden:NO];

                // We just have one enter event. Grey out the others.
                [self.identifierToLabels enumerateKeysAndObjectsUsingBlock:^(NSString *key2, UILabel *label2, BOOL *stop2){
                    if (![key2 isEqualToString:identifier]) {
                        [label2 setAlpha:0.2];
                    }
                }];

            } else if ([type isEqualToString:@"didExitRegion"]) {
                [label setHidden:YES];
            } else {
                NSLog(@"ERROR: key: %@, type: %@", identifier, type);
            }
        }
    }];
}

@end
