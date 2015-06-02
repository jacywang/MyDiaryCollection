//
//  ViewController.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/1/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "DiaryEntryViewController.h"


@interface DiaryEntryViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

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

- (IBAction)imagePickerButtonPressed:(UIButton *)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        
        actionSheet.tag = 0;
        
        [actionSheet showInView:self.view];
    
    }
    else {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
        default:
            break;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showLogin"]) {
        
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
    }
}
@end
