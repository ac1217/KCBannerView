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

//@"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
//@"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
//@"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
//@"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
//@"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
//
//@"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
//
//@"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
//
//@"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
//
//@"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"

- (NSArray *)banners
{
    if (!_banners) {
        
        KCBanner *banner0 = [[KCBanner alloc] init];
        banner0.picUrl = [NSURL URLWithString:@"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg"];
        banner0.title = @"sdfdsfsfsfsdfds";
        
        KCBanner *banner1 = [[KCBanner alloc] init];
        banner1.picUrl = [NSURL URLWithString:@"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg"];
        banner1.title = @"sdfdsfsfsadfasdfasdfasdfsasfsdfds";
//
//        
        KCBanner *banner2 = [[KCBanner alloc] init];
        banner2.picUrl = [NSURL URLWithString:@"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg"];
        banner2.title = @"sdfdssdafafasdfsfsfsdfds";
        
        
        KCBanner *banner3 = [[KCBanner alloc] init];
        banner3.picUrl = [NSURL URLWithString:@"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"];
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
