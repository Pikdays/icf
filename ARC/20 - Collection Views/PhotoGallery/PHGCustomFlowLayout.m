//
//  PHGCustomFlowLayout.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/16/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomFlowLayout.h"
#import "PHGRowDecorationView.h"

#define kDecorationYAdjustment  13.0
#define kDecorationHeight       25.0

@interface PHGCustomFlowLayout ()
@property(nonatomic, strong) NSDictionary *rowDecorationRects;
@end

@implementation PHGCustomFlowLayout

#pragma mark - ⊂((・猿・))⊃ Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(60, 60);
        self.sectionInset = UIEdgeInsetsMake(10, 26, 10, 26);
        self.headerReferenceSize = CGSizeMake(300, 50);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 40;

        [self registerClass:[PHGRowDecorationView class] forDecorationViewOfKind:[PHGRowDecorationView kind]];
    }
    return self;
}

#pragma mark - ⊂((・猿・))⊃ Override

- (void)prepareLayout {
    [super prepareLayout];

    // 有多少组
    NSInteger sections = [self.collectionView numberOfSections];

    // 一行有多少个
    CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
    NSInteger cellsPerRow = floorf((availableWidth + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing));

    NSMutableDictionary *rowDecorationWork = [[NSMutableDictionary alloc] init];
    CGFloat yPosition = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < sections; sectionIndex++) {
        yPosition += self.headerReferenceSize.height;
        yPosition += self.sectionInset.top;

        // 这组有多少个
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:sectionIndex];

        // 有多少行
        NSInteger rows = ceilf(cellCount / (CGFloat) cellsPerRow);
        for (int row = 0; row < rows; row++) {
            yPosition += self.itemSize.height;

            CGRect decorationFrame = CGRectMake(0, yPosition - kDecorationYAdjustment, self.collectionViewContentSize.width, kDecorationHeight);
            NSIndexPath *decIndexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
            rowDecorationWork[decIndexPath] = [NSValue valueWithCGRect:decorationFrame];

            if (row < rows - 1)
                yPosition += self.minimumLineSpacing;
        }

        yPosition += self.sectionInset.bottom;
        yPosition += self.footerReferenceSize.height;
    }
    self.rowDecorationRects = [NSDictionary dictionaryWithDictionary:rowDecorationWork];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];

    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        attributes.zIndex = 1;
    }

    NSMutableArray *newLayoutAttributes = layoutAttributes.mutableCopy;
    [self.rowDecorationRects enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *rowRectValue, BOOL *stop) {
        if (CGRectIntersectsRect([rowRectValue CGRectValue], rect)) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[PHGRowDecorationView kind] withIndexPath:indexPath];
            attributes.frame = [rowRectValue CGRectValue];
            attributes.zIndex = 0;
            [newLayoutAttributes addObject:attributes];
        }
    }];
    layoutAttributes = [NSArray arrayWithArray:newLayoutAttributes];

    return layoutAttributes;
}

@end
