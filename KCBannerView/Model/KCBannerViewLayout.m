//
//  KCBannerViewLayout.m
//  KCBannerViewDemo
//
//  Created by zhangweiwei on 16/6/30.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "KCBannerViewLayout.h"

@implementation KCBannerViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
}

/*

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect].copy;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
        
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            
            CGFloat delta = fabs(attr.center.x - collectionViewCenterX);
            
            CGFloat scale = 1 - delta / self.collectionView.frame.size.width * 0.5;
            
            attr.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }else {
        
        CGFloat collectionViewCenterY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
        
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            
            CGFloat delta = fabs(attr.center.y - collectionViewCenterY);
            
            CGFloat scale = 1 - delta / self.collectionView.frame.size.height * 0.5;
            
            attr.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    return attrs;
    
}
 */


@end
