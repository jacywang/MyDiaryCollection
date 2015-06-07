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
#import "HeaderReusableView.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CollectionViewFlowLayout *flowLayout = [[CollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 30);
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
        } else {
            self.diaryCollection = [NSMutableArray arrayWithArray:objects];
            self.filteredDiaryCollection = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (Diary *diary in self.diaryCollection) {
                NSString *monthString = [diary retrieveMonthHeaderString];
                if (dict[monthString]) {
                    [dict[monthString] addObject:diary];
                } else {
                    dict[monthString] = [NSMutableArray arrayWithArray:@[diary]];
                }
            }
            
            for (NSString *subject in dict) {
                [self.filteredDiaryCollection addObject:@[subject, dict[subject]]];
            }
            
            [self.collectionView reloadData];
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
    return self.filteredDiaryCollection.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filteredDiaryCollection[section][1] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Diary *diary = [self.filteredDiaryCollection[indexPath.section][1] objectAtIndex:indexPath.row];
    // Configure the cell
    
    [cell configureCell:diary];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyHeader" forIndexPath:indexPath];
        headerView.headerLabel.text = self.filteredDiaryCollection[indexPath.section][0];
        reusableView = headerView;
    }
    
    return reusableView;
}

@end
