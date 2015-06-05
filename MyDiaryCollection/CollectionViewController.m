//
//  CollectionViewController.m
//  MyDiaryCollection
//
//  Created by JIAN WANG on 6/2/15.
//  Copyright (c) 2015 JWANG. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "Diary.h"
#import "DiaryDetailViewController.h"
#import "CollectionViewFlowLayout.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CollectionViewFlowLayout *flowLayout = [[CollectionViewFlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PFQuery *query = [PFQuery queryWithClassName:@"Diary"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"userID" equalTo:[[PFUser currentUser] objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
        }
        else {
            self.diaryCollection = [NSMutableArray arrayWithArray:objects];
            [self.collectionView reloadData];
            
//            [UIView animateWithDuration:0 animations:^{
//                [self.collectionView performBatchUpdates:^{
//                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//                } completion:nil];
//            }];
            
            [UIView setAnimationsEnabled:NO];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } completion:^(BOOL finished) {
                [UIView setAnimationsEnabled:YES];
            }];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDiaryDetail"]) {
        
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        Diary *diary = [self.diaryCollection objectAtIndex:indexPath.row];
        DiaryDetailViewController *diaryDetailViewController = segue.destinationViewController;
        diaryDetailViewController.diary = diary;
        
        diaryDetailViewController.hidesBottomBarWhenPushed = YES;
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.diaryCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Diary *diary = [self.diaryCollection objectAtIndex:indexPath.row];
    // Configure the cell
    
    [cell configureCell:diary];
    
    return cell;
}

@end
