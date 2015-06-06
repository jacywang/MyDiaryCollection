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

-(NSString *)retrieveMonthHeaderString {
    
    NSDate *date = [self valueForKey:@"createdAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM yyyy"];
    NSString *monthHeaderString = [formatter stringFromDate:date];
    
    return monthHeaderString;

}

-(CLLocation *)convertGeoPointToCLLocation {
    
    PFGeoPoint *point = [self valueForKey:@"location"];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];

    return location;

}

@end
