//
//  DiaryDetailViewController.h
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"

@interface DiaryDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *diaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *diaryTextView;

@property (nonatomic, strong) Diary *diary;

@property (nonatomic, strong) UIImage *image;


@end
