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
@property (nonatomic, strong) NSDictionary *tagToButton;
@property (nonatomic, readonly) NSUserDefaults *defaults;
@end

@implementation LPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.identifierToLabels = @{ @"blue": self.blueLabel,
                                 @"green": self.greenLabel,
                                 @"purple": self.purpleLabel};

    self.blueButton.tag = 100;
    self.greenButton.tag = 200;
    self.purpleButton.tag = 300;
    self.tagToButton = @{@(100): @[self.blueButton,  @"blueButton"],
                         @(200): @[self.greenButton, @"greenButton"],
                         @(300): @[self.purpleButton,@"purpleButton"]};

    // Read from defaults
    NSString *blueButton = [self.defaults objectForKey:@"blueButton"];
    if (blueButton) {
        [self.blueButton setTitle:blueButton forState:UIControlStateNormal];
    }
    NSString *greenButton = [self.defaults objectForKey:@"greenButton"];
    if (greenButton) {
        [self.greenButton setTitle:greenButton forState:UIControlStateNormal];
    }
    NSString *purpleButton = [self.defaults objectForKey:@"purpleButton"];
    if (purpleButton) {
        [self.purpleButton setTitle:purpleButton forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUserDefaults *)defaults
{
    return [NSUserDefaults standardUserDefaults];
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

- (IBAction)changeTitle:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:sender.currentTitle
                                                        message:@"Enter new title"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = sender.tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *newTitle = textField.text;

    if (newTitle.length<=0) {
        return;
    }

    NSArray *buttonArry = [self.tagToButton objectForKey:@(alertView.tag)];
    UIButton *button = [buttonArry firstObject];
    [button setTitle:newTitle forState:UIControlStateNormal];

    [self.defaults setObject:newTitle forKey:[buttonArry lastObject]];
    [self.defaults synchronize];
}


@end
