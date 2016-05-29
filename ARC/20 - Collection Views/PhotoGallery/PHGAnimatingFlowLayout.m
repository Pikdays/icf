//
//  PHGAnimatingFlowLayout.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/22/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGAnimatingFlowLayout.h"
#import "PHGRowDecorationView.h"

#define kZoomDistance  150
#define kZoomAmount 0.5

@implementation PHGAnimatingFlowLayout

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
    }
    return self;
}

#pragma mark - ⊂((・猿・))⊃ Override

- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes =
            [super layoutAttributesForElementsInRect:rect];

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    for (UICollectionViewLayoutAttributes *attributes
            in layoutAttributes) {
        if (attributes.representedElementCategory ==
                UICollectionElementCategoryCell &&
                CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distanceFromCenter =
                    CGRectGetMidY(visibleRect) - attributes.center.y;

            CGFloat distancePercentFromCenter =
                    distanceFromCenter / kZoomDistance;

            if (ABS(distanceFromCenter) < kZoomDistance) {
                CGFloat zoom =
                        1 + kZoomAmount * (1 - ABS(distancePercentFromCenter));

                attributes.transform3D =
                        CATransform3DMakeScale(zoom, zoom, 1.0);
            }
            else {
                attributes.transform3D = CATransform3DIdentity;
            }
        }
    }

    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

@end
