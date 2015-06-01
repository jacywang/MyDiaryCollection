//
//  ViewController.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/1/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "DiaryEntryViewController.h"


@interface DiaryEntryViewController ()

@end

@implementation DiaryEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        
        NSLog(@"%@", currentUser.username);
        
    }
    else {
        
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}
@end
