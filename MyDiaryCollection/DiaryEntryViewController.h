//
//  ViewController.h
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/1/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>



@interface DiaryEntryViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *diaryTextView;
@property (weak, nonatomic) IBOutlet UIButton *imagePickerButton;
@property (strong, nonatomic) UIImage *diaryImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;
@property (weak, nonatomic) IBOutlet UIButton *saveDiaryButton;

- (IBAction)imagePickerButtonPressed:(UIButton *)sender;
- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveDiaryButtonPressed:(UIButton *)sender;

@end

