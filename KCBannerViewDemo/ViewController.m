//
//  ViewController.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "ViewController.h"
#import "KCBannerView.h"
#import "KCBanner.h"
@interface ViewController ()<KCBannerViewDelegate,KCBannerViewDatasource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *banners;


@property (nonatomic, strong) KCBannerView *bannerView;

@property (nonatomic, strong) UIScrollView *sv;


@end

@implementation ViewController

- (UIScrollView *)sv
{
    if (!_sv) {
        _sv = [[UIScrollView alloc] init];
        _sv.delegate = self;
    }
    return _sv;
}

- (NSArray *)banners
{
    if (!_banners) {
        
        KCBanner *banner0 = [[KCBanner alloc] init];
        banner0.url = [NSURL URLWithString:@"http://pic29.nipic.com/20130530/6434097_113007064309_2.jpg"];
        
        KCBanner *banner1 = [[KCBanner alloc] init];
        banner1.url = [NSURL URLWithString:@"http://pic50.nipic.com/file/20141010/19650248_153632125000_2.jpg"];
        banner1.title = @"sdfdsfsfsadfasdfasdfasdfsasfsdfds";
//
//        
        KCBanner *banner2 = [[KCBanner alloc] init];
        banner2.url = [NSURL URLWithString:@"http://pic29.nipic.com/20130530/6434097_113007064309_2.jpg"];
        
        
        KCBanner *banner3 = [[KCBanner alloc] init];
        banner3.url = [NSURL URLWithString:@"http://pic50.nipic.com/file/20141010/19650248_153632125000_2.jpg"];
        banner3.title = @"sdfdsfsfsfssadfsafsafdfds";
        banner3.placeholderImage = [UIImage imageNamed:@"pic_default_icon"];
        
        _banners = @[banner0, banner1, banner2, banner3];
//        _banners = @[banner0];
    }
    
    return _banners;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup afte
    
    [self.view addSubview:self.sv];
    
    // 创建
    KCBannerView *bannerView = [[KCBannerView alloc] init];
    
    bannerView.placeholderImageView.image = [UIImage imageNamed:@"pic"];
    // 设置代理
    bannerView.delegate = self;
    // 数据源
    bannerView.datasource = self;
    // 添加
    [self.sv addSubview:bannerView];
    
    self.bannerView = bannerView;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.bannerView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.sv.frame = self.view.bounds;
    
    self.bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    
    self.sv.contentSize = CGSizeMake(0, 1000);
}

#pragma mark -KCBannerViewDelegate
- (void)bannerView:(KCBannerView *)bannerView didSelectBannerAtIndex:(NSInteger)index
{
    
    [bannerView reloadData];
}

#pragma mark -KCBannerViewDatasource
- (KCBanner *)bannerView:(KCBannerView *)bannerView bannerForItemAtIndex:(NSInteger)index
{
    return self.banners[index];
}

- (NSInteger)numberOfBannersInBannerView:(KCBannerView *)bannerView
{
    return self.banners.count;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.bannerView.repeat = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.bannerView.repeat = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.bannerView.contentOffset = scrollView.contentOffset;
}


@end
