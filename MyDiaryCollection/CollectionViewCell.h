//
//  CollectionViewCell.h
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "Diary.h"

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet PFImageView *diaryImageView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)configureCell:(Diary *)diary;

@end
