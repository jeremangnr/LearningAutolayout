//
//  LAViewController.m
//  LearningAutolayout
//
//  Created by Jeremias Nuñez on 10/18/13.
//  Copyright (c) 2013 Globant. All rights reserved.
//

#import "LAListViewController.h"
#import "LAItemCell.h"

static NSString * const cellIdentifier = @"ItemCell";

@interface LAListViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LAListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LAItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

@end
