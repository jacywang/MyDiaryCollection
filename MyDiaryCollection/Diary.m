//
//  Diary.m
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-02.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "Diary.h"
#import <Parse/PFObject+Subclass.h>


@implementation Diary

@dynamic diaryText;

@dynamic imageFile;

@dynamic location;

@dynamic userID;

@synthesize image;


+(void)load {
    
    [self registerSubclass];
    
}

+(NSString *)parseClassName {
    
    return @"Diary";
    
}

-(NSString *)convertDateToString {
    
    NSDate *date = [self valueForKey:@"createdAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}

-(CLLocation *)convertGeoPointToCLLocation {
    
    PFGeoPoint *point = [self valueForKey:@"location"];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];

    return location;

}

-(void)downloadImage {
    
    PFFile *imageFile = self[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            self.image = [UIImage imageWithData:data];
            
        }
        
    }];
}

@end
