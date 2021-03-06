//
//  CollectionViewCell.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)configureCell:(Diary *)diary {
    
    self.dateLabel.text = [diary convertDateToDay];
    self.dateLabel.clipsToBounds = YES;
    self.dateLabel.layer.cornerRadius = 5.0f;
    
//    self.layer.borderColor = [UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor;
//    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    
    self.diaryImageView.image = [UIImage imageNamed:@"icn_picture"]; // placeholder image
    self.diaryImageView.file = diary[@"imageFile"]; // remote image
    [self.diaryImageView loadInBackground];

}


@end
