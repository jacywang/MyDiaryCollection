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
    NSDate *date = [diary valueForKey:@"createdAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    self.dateLabel.text = dateString;
}


@end
