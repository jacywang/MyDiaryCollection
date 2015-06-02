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

@end
