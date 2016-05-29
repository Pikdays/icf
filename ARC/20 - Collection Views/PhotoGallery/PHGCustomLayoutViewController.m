//
//  PHGCustomLayoutViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomLayoutViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGCustomLayout.h"
#import "PHGAnimatingFlowLayout.h"

NSString *kCustomCell = @"kCustomCell"; // UICollectionViewCell storyboard id
NSString *kCustomSectionHdr = @"kCustomSectionHeader"; //section header storyboard id

@interface PHGCustomLayoutViewController ()
@property(nonatomic, strong) PHGCustomLayout *customLayout;

@property(nonatomic, strong) NSMutableArray *assetArray;
@property(nonatomic, strong) NSMutableArray *assetGroupArray;
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property(nonatomic, strong) NSIndexPath *pinchedIndexPath;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchIn;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchOut;

@end

@implementation PHGCustomLayoutViewController

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
    [self.collectionView setCollectionViewLayout:[[PHGCustomLayout alloc] init]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PHGCustomSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHdr];

    [self addGesture];
}

#pragma mark - ⊂((・猿・))⊃ Action
#pragma mark - Gesture

- (void)addGesture {
    self.pinchIn = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchInReceived:)];
    self.pinchOut = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchOutReceived:)];
    [self.collectionView addGestureRecognizer:self.pinchOut];
}

- (void)pinchInReceived:(UIGestureRecognizer *)pinchRecognizer {
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchPoint = [pinchRecognizer locationInView:self.collectionView];
        self.pinchedIndexPath = [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchIn];

        PHGCustomLayout *customLayout = [[PHGCustomLayout alloc] init];

        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchOut = self.pinchOut;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        [self.collectionView setCollectionViewLayout:customLayout animated:YES completion:^(BOOL finished) {
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            [weakCollectionView addGestureRecognizer:weakPinchOut];
        }];
    }
}

- (void)pinchOutReceived:(UIGestureRecognizer *)pinchRecognizer {
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchPoint = [pinchRecognizer locationInView:self.collectionView];
        self.pinchedIndexPath = [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchOut];

        UICollectionViewFlowLayout *individualLayout = [[PHGAnimatingFlowLayout alloc] init];

        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchIn = self.pinchIn;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        [self.collectionView setCollectionViewLayout:individualLayout animated:YES completion:^(BOOL finished) {
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            [weakCollectionView addGestureRecognizer:weakPinchIn];
        }];
    }
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
    PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHdr forIndexPath:indexPath];
    [sectionHeader.headerLabel setText:self.assetGroupArray[indexPath.section]];

    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];

    ALAsset *assetForPath = self.assetArray[indexPath.section][indexPath.row];
    UIImage *assetThumb = [UIImage imageWithCGImage:[assetForPath thumbnail]];
    [cell.thumbImageView setImage:assetThumb];

    return cell;
}

@end
