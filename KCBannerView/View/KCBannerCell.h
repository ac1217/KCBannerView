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

@protocol KCBannerProtocol <NSObject>

@optional
- (NSURL *)picUrl;
- (UIImage *)pic;
- (NSString *)title;

@end

@interface KCBannerCell : UICollectionViewCell
@property (nonatomic, strong) id<KCBannerProtocol> banner;


@property (nonatomic, weak, readonly) UIImageView *imageView;

@end
