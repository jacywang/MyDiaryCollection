//
//  CollectionViewCell.h
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *diaryImageView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)configureCell:(Diary *)diary;

@end
