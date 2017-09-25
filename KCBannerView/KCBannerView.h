//
//  KCPictureRepeatView.h
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KCBannerViewPageControlPosition) {
    KCBannerViewPageControlPositionCenter = 0,
    KCBannerViewPageControlPositionLeft,
    KCBannerViewPageControlPositionRight,
};

typedef NS_ENUM(NSInteger, KCBannerViewDescPosition) {
    KCBannerViewDescPositionTop = 0,
    KCBannerViewDescPositionBottom
};

@class KCBannerView;

// banner数据需要提供协议的接口
// 数据源
@protocol KCBannerViewDataSource <NSObject>

- (NSInteger)numberOfImagesInBannerView:(KCBannerView *)bannerView;

// 可以返回UIImage,NSString,NSURL,NSData类型
- (id)bannerView:(KCBannerView *)bannerView imageResourceAtIndex:(NSInteger)index;
//- (id <KCBannerProtocol>)bannerView:(KCBannerView *)bannerView bannerAtIndex:(NSInteger)index;

@optional
- (UIImage *)bannerView:(KCBannerView *)bannerView placeholderImageAtIndex:(NSInteger)index;
- (NSString *)bannerView:(KCBannerView *)bannerView descriptionStringAtIndex:(NSInteger)index;
- (NSAttributedString *)bannerView:(KCBannerView *)bannerView descriptionAttributedStringAtIndex:(NSInteger)index;

@end

// 代理协议
@protocol KCBannerViewDelegate <NSObject>

@optional
// 点击回调
- (void)bannerView:(KCBannerView *)bannerView didTapImageAtIndex:(NSInteger)index;


@end

@interface KCBannerView : UIView


/*kind of UIImage or imageNamed*/
@property (nonatomic, strong) UIImage *placeholderImage;
// 页数控件
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

// 当数据为空时显示的图片空间
@property (nonatomic, strong, readonly) UIImageView *emptyImageView;

// 代理
@property (nonatomic, weak) id<KCBannerViewDelegate> delegate;

// 数据源
@property (nonatomic, weak) id<KCBannerViewDataSource> dataSource;

// 循环间隔
@property (nonatomic, assign) CGFloat timeInterval;

// 是否循环轮播，默认为YES，当数据个数少于等于1时此值为NO
@property (nonatomic, assign, getter=isRepeat) BOOL repeat;

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) KCBannerViewPageControlPosition pageControlPosition;
@property (nonatomic, assign) KCBannerViewDescPosition descPosition;



- (void)setPageControlPageImage:(UIImage *)pageImage;

- (void)setPageControlCurrentPageImage:(UIImage *)currentPageImage;

// 刷新数据
- (void)reloadData;

// 偏移量,下拉图片缩放
@property (nonatomic, assign) CGPoint contentOffset;


@end
