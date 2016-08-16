//
//  KCBannerCell.h
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KCBanner;

extern NSString *const KCBannerCellReuseID;

@interface KCBannerCell : UICollectionViewCell
@property (nonatomic, strong) KCBanner *banner;


@property (nonatomic, weak, readonly) UIImageView *imageView;

@end
