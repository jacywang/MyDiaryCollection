//
//  Diary.h
//  MyDiaryCollection
//
//  Created by Ian Tsai on 2015-06-02.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Diary : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *diaryText;

@property (nonatomic, strong) PFFile *imageFile;

@property (nonatomic, strong) PFGeoPoint *location;

@property (nonatomic, strong) NSString *userID;


+ (NSString *)parseClassName;

@end
