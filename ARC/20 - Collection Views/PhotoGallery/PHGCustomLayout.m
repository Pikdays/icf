//
//  PHGCustomLayout.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomLayout.h"

#define kCellSize   50.0 //assumes square cell
#define kHorizontalInset    10.0 //on the left and right
#define kPi 3.141592653
#define kVerticalSpace  10.0  //vertical space between cells
#define kSectionHeight  20.0
#define kCenterXPosition    160.0
#define kMaxAmplitude   125.0

@interface PHGCustomLayout ()
@property(nonatomic, strong) NSMutableDictionary *centerPointsForCells;
@property(nonatomic, strong) NSMutableArray *rectsForSectionHeaders;
@property(nonatomic, assign) CGSize contentSize;
@end

@implementation PHGCustomLayout

#pragma mark - ⊂((・猿・))⊃ Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        //self.centerXPosition = self.collectionView.bounds.size.width / 2;
        //self.maxAmplitude = (self.collectionView.bounds.size.width - 2 * kHorizontalInset) / 2;
        //[self registerClass:[ShelfView class] forDecorationViewOfKind:[ShelfView kind]];
    }
    return self;
}

#pragma mark - ⊂((・猿・))⊃ Override

- (void)prepareLayout {
    NSInteger numSections = [self.collectionView numberOfSections];

    CGFloat currentYPosition = 0.0;
    self.centerPointsForCells = [[NSMutableDictionary alloc] init];
    self.rectsForSectionHeaders = [[NSMutableArray alloc] init];

    for (NSInteger sectionIndex = 0; sectionIndex < numSections; sectionIndex++) {
        CGRect rectForNextSection = CGRectMake(0, currentYPosition, self.collectionView.bounds.size.width, kSectionHeight);
        self.rectsForSectionHeaders[sectionIndex] = [NSValue valueWithCGRect:rectForNextSection];

        currentYPosition += kSectionHeight + kVerticalSpace + kCellSize / 2;
        NSInteger numCellsForSection = [self.collectionView numberOfItemsInSection:sectionIndex];

        for (NSInteger cellIndex = 0; cellIndex < numCellsForSection; cellIndex++) {
            CGFloat xPosition = [self calculateSineXPositionForY:currentYPosition];
            CGPoint cellCenterPoint = CGPointMake(xPosition, currentYPosition);
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
            self.centerPointsForCells[cellIndexPath] = [NSValue valueWithCGPoint:cellCenterPoint];
            currentYPosition += kCellSize + kVerticalSpace;
        }
    }

    self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, currentYPosition + kVerticalSpace);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(kCellSize, kCellSize);
    NSValue *centerPointValue = self.centerPointsForCells[path];
    attributes.center = [centerPointValue CGPointValue];

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    CGRect sectionRect = [self.rectsForSectionHeaders[indexPath.section] CGRectValue];
    attributes.size = CGSizeMake(sectionRect.size.width, sectionRect.size.height);
    attributes.center = CGPointMake(CGRectGetMidX(sectionRect), CGRectGetMidY(sectionRect));

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSValue *sectionRect in self.rectsForSectionHeaders) {
        if (CGRectIntersectsRect(rect, sectionRect.CGRectValue)) {
            NSInteger sectionIndex = [self.rectsForSectionHeaders indexOfObject:sectionRect];
            NSIndexPath *secIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:secIndexPath]];
        }
    }

    [self.centerPointsForCells enumerateKeysAndObjectsUsingBlock:
            ^(NSIndexPath *indexPath, NSValue *centerPoint, BOOL *stop) {
                CGPoint center = [centerPoint CGPointValue];
                CGRect cellRect = CGRectMake(center.x - kCellSize / 2, center.y - kCellSize / 2, kCellSize, kCellSize);
                if (CGRectIntersectsRect(rect, cellRect)) {
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
                }
            }];

    return [NSArray arrayWithArray:attributes];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

#pragma mark - ⊂((・猿・))⊃ Set_Get

- (CGFloat)calculateSineXPositionForY:(CGFloat)yPosition {
    CGFloat currentTime = (yPosition / self.collectionView.bounds.size.height);
    CGFloat sineCalc = kMaxAmplitude * sinf(2 * kPi * currentTime);
    CGFloat adjustedXPosition = sineCalc + kCenterXPosition;
    return adjustedXPosition;
}

@end
