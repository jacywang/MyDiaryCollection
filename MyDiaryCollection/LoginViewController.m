//
//  LoginViewController.m
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-01.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0 || password.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"oops" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"oops" message:@"Please make sure your username and password are correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}
@end
