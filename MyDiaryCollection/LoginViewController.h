//
//  LoginViewController.h
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-01.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)loginButtonPressed:(UIButton *)sender;


@end
