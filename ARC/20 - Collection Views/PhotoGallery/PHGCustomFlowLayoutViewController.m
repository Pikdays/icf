//
//  PHGCustomFlowLayoutViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/13/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomFlowLayoutViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGCustomFlowLayout.h"

NSString *kCustomThumbCell = @"kCustomThumbCell"; // UICollectionViewCell storyboard id
NSString *kCustomSectionHeader = @"kCustomSectionHeader"; //section header storyboard id

@interface PHGCustomFlowLayoutViewController ()

@property(nonatomic, strong) UICollectionViewFlowLayout *pageLayout;

@property(nonatomic, strong) NSMutableArray *assetArray;
@property(nonatomic, strong) NSMutableArray *assetGroupArray;
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation PHGCustomFlowLayoutViewController

#pragma mark - ⊂((・猿・))⊃ LifeCycle

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
                                              NSString *sectionTitle = [NSString stringWithFormat:@"%@ - %d", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
                                              [self.assetGroupArray addObject:sectionTitle];
                                              [self enumerateGroupAssetsForGroup:group];
                                          }
                                          else {
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
    [self.collectionView setCollectionViewLayout:[[PHGCustomFlowLayout alloc] init]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PHGSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHeader];

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
    PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHeader forIndexPath:indexPath];
    [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];

    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCustomThumbCell forIndexPath:indexPath];

    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];

    [cell.thumbImageView setImage:assetThumb];

    return cell;
}

@end
