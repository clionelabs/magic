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
    // only show the label matching on the identifier.
    NSString *identifier = [location objectForKey:@"identifier"];
    [self.identifierToLabels enumerateKeysAndObjectsUsingBlock:^(NSString *key, UILabel *label, BOOL *stop){
        if ([key isEqualToString:identifier]) {
            [label setHidden:NO];
        } else {
            [label setHidden:YES];
        }
    }];
}

@end
