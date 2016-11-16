//
//  KCBannerCell.h
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KCBanner;
@protocol KCBannerProtocol;

typedef NS_ENUM(NSInteger, KCBannerCellDescPosition) {
    KCBannerCellDescPositionTop = 0,
    KCBannerCellDescPositionBottom
};

extern NSString *const KCBannerCellReuseID;

@interface KCBannerCell : UICollectionViewCell
@property (nonatomic, strong) id <KCBannerProtocol> banner;

@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, assign) KCBannerCellDescPosition descPosition;

@end
