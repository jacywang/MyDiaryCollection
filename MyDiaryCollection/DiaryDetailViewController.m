//
//  DiaryDetailViewController.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface DiaryDetailViewController ()

@end

@implementation DiaryDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configure];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configure {
    
    self.title = [self.diary convertDateToString];
    self.diaryTextView.text = [self.diary valueForKey:@"diaryText"];

    PFFile *imageFile = self.diary[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            self.diaryImageView.image = [UIImage imageWithData:data];
            
        }
        
    }];

    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    [geocode reverseGeocodeLocation:[self.diary convertGeoPointToCLLocation] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        self.addressLabel.text = placemark.name;
        
    }];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
