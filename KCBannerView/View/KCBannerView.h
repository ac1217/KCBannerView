//
//  KCPictureRepeatView.h
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCBanner.h"
@class KCBannerView;

// banner数据需要提供协议的接口
@protocol KCBannerProtocol;

// 数据源
@protocol KCBannerViewDatasource <NSObject>

- (NSInteger)numberOfBannersInBannerView:(KCBannerView *)bannerView;

- (id<KCBannerProtocol>)bannerView:(KCBannerView *)bannerView bannerForItemAtIndex:(NSInteger)index;

@end

// 代理协议
@protocol KCBannerViewDelegate <NSObject>

@optional
// 点击回调
- (void)bannerView:(KCBannerView *)bannerView didSelectBannerAtIndex:(NSInteger)index;

@end

@interface KCBannerView : UIView

// 页数控件
@property (nonatomic, weak, readonly) UIPageControl *pageControl;

// 代理
@property (nonatomic, weak) id<KCBannerViewDelegate> delegate;

// 数据源
@property (nonatomic, weak) id<KCBannerViewDatasource> datasource;

// 循环间隔
@property (nonatomic, assign) CGFloat timeInterval;

// 是否循环轮播，默认为YES，当数据数组个数少于等于1时此值为NO
@property (nonatomic, assign, getter=isRepeat) BOOL repeat;

// 刷新数据
- (void)reloadData;

@end
