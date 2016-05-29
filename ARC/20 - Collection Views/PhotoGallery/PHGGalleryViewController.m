//
//  PHGGalleryViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 6/4/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGGalleryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGSectionFooter.h"

//NSString *kThumbCell = @"kThumbCell"; // UICollectionViewCell storyboard id
//NSString *kSectionHeader = @"kSectionHeader"; //section header storyboard id
//NSString *kSectionFooter = @"kSectionFooter"; //section header storyboard id

@interface PHGGalleryViewController ()
@property(nonatomic, strong) UICollectionViewFlowLayout *pageLayout;

@property(nonatomic, strong) NSMutableArray *assetArray;
@property(nonatomic, strong) NSMutableArray *assetGroupArray;
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property(nonatomic, assign) BOOL displayingPageLayout;

@end

@implementation PHGGalleryViewController

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
    [self.collectionView setCollectionViewLayout:self.pageLayout animated:YES];
    self.displayingPageLayout = YES;
}

#pragma mark - ⊂((・猿・))⊃ Set_Get

- (UICollectionViewFlowLayout *)pageLayout {
    if (!_pageLayout) {
        _pageLayout = [[UICollectionViewFlowLayout alloc] init];
        [_pageLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_pageLayout setItemSize:CGSizeMake(300, 300)];
    }
    return _pageLayout;
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

/*//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeader forIndexPath:indexPath];
//        
//        [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];
//        
//        supplementaryView = sectionHeader;
//    }
//
//    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        PHGSectionFooter *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionFooter forIndexPath:indexPath];
//        
//        NSString *footerString = [NSString stringWithFormat:@"...end of %@",self.assetGroupArray[indexPath.section]];
//        [sectionFooter.footerLabel setText:footerString];
//        
//        supplementaryView = sectionFooter;
//    }*/

    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
//    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kThumbCell forIndexPath:indexPath];

    PHGThumbCell *cell = nil;
    // make the cell's title the actual NSIndexPath value
    //cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];

    // load the image for this cell

    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    if (self.displayingPageLayout) {
        ALAssetRepresentation *assetRep = [assetForPath defaultRepresentation];
        UIImage *assetImage = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
        [cell.thumbImageView setImage:assetImage];
    } else {
        UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];
        [cell.thumbImageView setImage:assetThumb];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Item selected");
}

@end
