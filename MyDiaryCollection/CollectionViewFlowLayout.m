//
//  CollectionViewFlowLayout.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/4/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

# pragma mark - Constants

#define CENTER_OFFSET_BOUND		20
#define ROTATION_ANGLE_BOUND	5 // degrees

# pragma mark - Macros

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation CollectionViewFlowLayout

-(instancetype)init {
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 10;
        float size = ([UIScreen mainScreen].bounds.size.width - 4 * self.minimumInteritemSpacing) / 3;
        self.itemSize = CGSizeMake(size, size);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.minimumLineSpacing = 20;
    }
    return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* allAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // Determine attributes for cells, supplementary views, and decoration views in rectangle
    for (UICollectionViewLayoutAttributes* attributes in allAttributes) {
        
        // All elements initially at Z level 1
        attributes.zIndex = 1;
        
        // Cells
//        [CollectionViewFlowLayout tweakCellAttributes:attributes];
    }
    
    return allAttributes;
}

//+ (void)tweakCellAttributes:(UICollectionViewLayoutAttributes*)cellAttributes {
//    
//    if (cellAttributes.representedElementCategory != UICollectionElementCategoryCell) return;
//    
//    // Offset center by bounded random amount
//    double centerXOffset = arc4random_uniform(CENTER_OFFSET_BOUND + 1) - (CENTER_OFFSET_BOUND / 2.0);
//    double centerYOffset = arc4random_uniform(CENTER_OFFSET_BOUND + 1) - (CENTER_OFFSET_BOUND / 2.0);
//    cellAttributes.center = CGPointMake(cellAttributes.center.x + centerXOffset,
//                                        cellAttributes.center.y + centerYOffset);
//    
//    // Rotate by bounded random angle
//    double rotationAngle = arc4random_uniform(ROTATION_ANGLE_BOUND + 1) - (ROTATION_ANGLE_BOUND / 2.0);
//    cellAttributes.transform = CGAffineTransformMakeRotation(RADIANS(rotationAngle));
//}

@end
