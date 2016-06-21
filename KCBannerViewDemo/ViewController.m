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
@interface ViewController ()<KCBannerViewDelegate,KCBannerViewDatasource>

@property (nonatomic, strong) NSArray *banners;

@end

@implementation ViewController

- (NSArray *)banners
{
    if (!_banners) {
        
        KCBanner *banner0 = [[KCBanner alloc] init];
        banner0.picUrl = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/pic/item/562c11dfa9ec8a13f075f10cf303918fa1ecc0eb.jpg"];
        banner0.title = @"sdfdsfsfsfsdfds";
        
        KCBanner *banner1 = [[KCBanner alloc] init];
        banner1.picUrl = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/pic/item/cb8065380cd7912344a13298a9345982b3b7809d.jpg"];
        banner1.title = @"sdfdsfsfsadfasdfasdfasdfsasfsdfds";
//
//        
        KCBanner *banner2 = [[KCBanner alloc] init];
        banner2.picUrl = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/4a36acaf2edda3cc9de31ecc05e93901203f92d3.jpg"];
        banner2.title = @"sdfdssdafafasdfsfsfsdfds";
        
        
        KCBanner *banner3 = [[KCBanner alloc] init];
        banner3.picUrl = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f41348a8ca392211f95cad0c85ea6.jpg"];
        banner3.title = @"sdfdsfsfsfssadfsafsafdfds";
        
        _banners = @[banner0, banner1, banner2, banner3];
//        _banners = @[banner0];
    }
    
    return _banners;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建
    KCBannerView *bannerView = [[KCBannerView alloc] initWithFrame:CGRectMake(50, 100, 300, 150)];
    // 设置代理
    bannerView.delegate = self;
    // 数据源
    bannerView.datasource = self;
    // 添加
    [self.view addSubview:bannerView];
    
//    self.view.layer.cornerRadius
    
    
}
#pragma mark -KCBannerViewDelegate
- (void)bannerView:(KCBannerView *)bannerView didSelectBannerAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}

#pragma mark -KCBannerViewDatasource
- (id<KCBannerProtocol>)bannerView:(KCBannerView *)bannerView bannerForItemAtIndex:(NSInteger)index
{
    return self.banners[index];
}

- (NSInteger)numberOfBannersInBannerView:(KCBannerView *)bannerView
{
    return self.banners.count;
}

@end
