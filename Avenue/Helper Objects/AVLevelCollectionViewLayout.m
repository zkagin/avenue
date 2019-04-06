//
//  AVLevelCollectionViewLayout.m
//  Avenue
//
//  Created by Zach Kagin on 9/2/17.
//  Copyright © 2017 Zach Kagin. All rights reserved.
//

#import "AVLevelCollectionViewLayout.h"

@implementation AVLevelCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray<UICollectionViewLayoutAttributes *> *newAttributes = [[NSArray alloc] initWithArray:originalAttributes
                                                                                      copyItems:YES];
    for (UICollectionViewLayoutAttributes *attributes in newAttributes) {
        CGRect visibleRect = CGRectZero;
        visibleRect.origin = self.collectionView.contentOffset;
        visibleRect.size = self.collectionView.bounds.size;
        const CGFloat halfWidth = self.collectionView.bounds.size.width;

        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        if (ABS(distance) < halfWidth) {
            CGFloat alpha = MAX(1.f - 1.25f * ABS(distance / halfWidth), 0.f);
            attributes.alpha = alpha;

            CGFloat zoom = 2 - ABS(distance / halfWidth);
            // distance: 0, value = 0.5
            // distance: halfWidth, value = 0.
            attributes.transform = CGAffineTransformMakeScale(zoom, zoom);
        }
    }
    return newAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    CGFloat horizontalOffset = proposedContentOffset.x + self.collectionView.contentInset.left;

    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width,
                                   self.collectionView.bounds.size.height);

    for (UICollectionViewLayoutAttributes *attributes in [self layoutAttributesForElementsInRect:targetRect]) {
        UICollectionViewLayoutAttributes *newAttributes = [attributes copy];
        newAttributes.transform = CGAffineTransformIdentity;
        CGFloat itemOffset = newAttributes.frame.origin.x;
        if (fabsf((float)(itemOffset - horizontalOffset)) < fabsf((float)offsetAdjustment)) {
            offsetAdjustment = itemOffset - horizontalOffset;
        }
    }

    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
