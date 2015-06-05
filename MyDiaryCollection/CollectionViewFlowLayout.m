//
//  CollectionViewFlowLayout.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/4/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

-(instancetype)init {
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 10;
        float size = ([UIScreen mainScreen].bounds.size.width - 4 * self.minimumInteritemSpacing) / 3;
        self.itemSize = CGSizeMake(size, size);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.minimumLineSpacing = 10;
    }
    return self;
}

@end
