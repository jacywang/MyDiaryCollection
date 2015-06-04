//
//  ViewController.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/1/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "DiaryEntryViewController.h"
#import "Diary.h"


@interface DiaryEntryViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>

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
    
    self.imagePickerButton.clipsToBounds = YES;
    self.imagePickerButton.layer.cornerRadius = 10;
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.diaryImage) {
        
        [self.imagePickerButton setImage:self.diaryImage forState:UIControlStateNormal];
        
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = 50;
        self.locationManager.distanceFilter = 50;
        [self.locationManager startUpdatingLocation];
        
        self.userLocation = [[CLLocation alloc] init];
        
    } else {
        
        [self.imagePickerButton setImage:[UIImage imageNamed:@"icn_picture"] forState:UIControlStateNormal];
        
    }
    
    [self.imagePickerButton setContentMode:UIViewContentModeScaleAspectFit];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showLogin"]) {
        
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
    }
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}

- (IBAction)saveDiaryButtonPressed:(UIButton *)sender {
    

    NSData *fileData;
    NSString *fileName;
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[self roundToThreeDigits:self.userLocation.coordinate.latitude] longitude:[self roundToThreeDigits:self.userLocation.coordinate.longitude]];
    
    fileData = UIImageJPEGRepresentation(self.diaryImage, 0.85);
    fileName = @"image.jpg";
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please save your Diary Entry again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
        else {
            
            Diary *diary = [Diary object];
            diary.userID = [[PFUser currentUser] objectId];
            diary.imageFile = file;
            diary.diaryText = self.diaryTextView.text;
            diary.location = point;
            [diary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                if (succeeded) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your diary entry is saved" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:defaultAction];
                    [self presentViewController:alertController animated:YES completion:^{
                        
                        self.diaryTextView.text = nil;
                        self.diaryImage = nil;
                        
                        [self.tabBarController setSelectedIndex:1];
                        
                    }];
                    
                    
                    
                }
                else {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Please save your Diary Entry again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                
                
            }];
        }
        
    }];
  
}

-(double)roundToThreeDigits:(double)num {
    
    return (int)(roundf(num * 1000.0)) / 1000.0;
    
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

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.diaryImage = info[UIImagePickerControllerEditedImage];

    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheetDelegate

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

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    self.userLocation = [locations lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error %@", [error localizedDescription]);
}

@end
