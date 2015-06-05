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
    
    self.dateLabel.text = [diary convertDateToString];

//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowRadius = 5.0f;
//    self.layer.shadowOffset = CGSizeZero;

}


@end
