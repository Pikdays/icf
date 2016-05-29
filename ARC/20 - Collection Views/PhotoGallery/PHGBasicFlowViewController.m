//
//  PHGBasicFlowViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/20/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGBasicFlowViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGSectionFooter.h"

NSString *kThumbCell = @"kThumbCell"; // UICollectionViewCell storyboard id
NSString *kSectionHeader = @"kSectionHeader"; //section header storyboard id
NSString *kSectionFooter = @"kSectionFooter"; //section header storyboard id

@interface PHGBasicFlowViewController ()

@property(nonatomic, strong) UICollectionViewFlowLayout *pageLayout;

@property(nonatomic, strong) NSMutableArray *assetArray; // ALAsset
@property(nonatomic, strong) NSMutableArray *assetGroupArray; // ALAssetsGroup
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation PHGBasicFlowViewController

#pragma mark - ⊂((・猿・))⊃ Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    [self setupUI];
}

#pragma mark - ⊂((・猿・))⊃ SetupData

- (void)setupData {
    self.assetArray = [[NSMutableArray alloc] init];
    self.assetGroupArray = [[NSMutableArray alloc] init];
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          if (group) {
                                              NSString *sectionTitle = [NSString stringWithFormat:@"%@ - %ld", [group valueForProperty:ALAssetsGroupPropertyName], (long) [group numberOfAssets]];
                                              [self.assetGroupArray addObject:sectionTitle];
                                              [self enumerateGroupAssetsForGroup:group];
                                          } else {
                                              [self.collectionView reloadData];
                                          }
                                      }
                                    failureBlock:^(NSError *error) {
                                    }
    ];

}

- (void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group {
    NSInteger lastIndex = [group numberOfAssets] - 1;

    __block NSMutableArray *groupAssetArray = [[NSMutableArray alloc] init];

    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            [groupAssetArray addObject:result];
        }

        if (index == lastIndex) {
            [self.assetArray addObject:groupAssetArray];
        }

    }];
}

#pragma mark - ⊂((・猿・))⊃ SetupUI

- (void)setupUI {
    [self.collectionView setAllowsMultipleSelection:YES];
}

#pragma mark - ⊂((・猿・))⊃ Action

- (IBAction)actionTapped:(id)sender {
    NSString *message = nil;
    if ([self.collectionView.indexPathsForSelectedItems count] == 0) {
        message = @"There are no selected items.";
    } else if ([self.collectionView.indexPathsForSelectedItems count] == 1) {
        message = @"There is 1 selected item.";
    } else if ([self.collectionView.indexPathsForSelectedItems count] > 1) {
        message = [NSString stringWithFormat:@"There are %lu selected items.", [self.collectionView.indexPathsForSelectedItems count]];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Items" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - ⊂((・猿・))⊃ Delegate
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.assetGroupArray count];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section; {
    return [self.assetArray[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView = nil;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeader forIndexPath:indexPath];
        [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];

        supplementaryView = sectionHeader;
    }

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PHGSectionFooter *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionFooter forIndexPath:indexPath];
        NSString *footerString = [NSString stringWithFormat:@"...end of %@", self.assetGroupArray[indexPath.section]];
        [sectionFooter.footerLabel setText:footerString];

        supplementaryView = sectionFooter;
    }

    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kThumbCell forIndexPath:indexPath];

    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];

    [cell.thumbImageView setImage:assetThumb];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Item selected at indexPath: %@", indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Item deselected at indexPath: %@", indexPath);
}

@end
