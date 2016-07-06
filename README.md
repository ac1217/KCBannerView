# KCBannerView

#示例代码：
 // 创建
    KCBannerView *bannerView = [[KCBannerView alloc] initWithScrollView:self.sv]; // 使用此方法初始化为开启下拉banner缩放功能
    // KCBannerView *bannerView = [[KCBannerView alloc] init]; // 使用此方法初始化只带普通图片浏览功能
    
    // 设置代理
    bannerView.delegate = self;
    // 数据源
    bannerView.datasource = self;
    // 添加
    [self.sv addSubview:bannerView];
    
    bannerView.scrollDirection = KCBannerViewScrollDirectionVertical;
    
    self.bannerView = bannerView;


#如果开启banner缩放功能，建议实现scrollView这两个代理方法，并在代理方法做如下操作
#pragma mark scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.bannerView.repeat = NO;// 停止轮播
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.bannerView.repeat = YES;// 启动轮播
}
