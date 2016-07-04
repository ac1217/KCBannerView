//
//  KCPictureRepeatView.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "KCBannerView.h"
#import "KCBannerCell.h"
#import "KCBanner.h"
#import "KCBannerViewLayout.h"


static const NSInteger KCMaxSection = 100;

@interface KCBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>{
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) UIScrollView *sv;

@end

@implementation KCBannerView

#pragma mark -内部方法

- (void)addTimer
{
    if (!self.isRepeat) return;
    
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    NSIndexPath *resetIndexPath = [self resetIndexPath];
    
    NSInteger item = resetIndexPath.item + 1;
    NSInteger section = resetIndexPath.section;
    
    if (item == [self.datasource numberOfBannersInBannerView:self]) {
        item = 0;
        section++;
    }
    
    if (self.scrollDirection == KCBannerViewScrollDirectionHorizontal) {
        
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
    
    
}

- (NSIndexPath *)resetIndexPath
{
    NSIndexPath *visibleIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *resetIndexPath = [NSIndexPath indexPathForItem:visibleIndexPath.item inSection:KCMaxSection / 2];
    
    if (self.scrollDirection == KCBannerViewScrollDirectionHorizontal) {
        
        [self.collectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        
        [self.collectionView scrollToItemAtIndexPath:resetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
    
    
    return resetIndexPath;
}

#pragma mark -初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.timeInterval = 5.0;
    self.repeat = YES;
    self.scrollDirection = KCBannerViewScrollDirectionHorizontal;
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat pageWH = 15;
    CGFloat pageControlH = pageWH;
    CGFloat pageControlW = pageWH * self.pageControl.numberOfPages;
    
    CGFloat pageControlX = (self.frame.size.width - pageControlW) * 0.5;
    CGFloat pageControlY = self.frame.size.height - pageControlH;
    
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    self.collectionView.frame = self.bounds;
    
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.datasource numberOfBannersInBannerView:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.datasource numberOfBannersInBannerView:self] <= 1 ? 1 : KCMaxSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCBannerCellReuseID forIndexPath:indexPath];
    
    cell.banner = [self.datasource bannerView:self bannerForItemAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectBannerAtIndex:)]) {
        [self.delegate bannerView:self didSelectBannerAtIndex:indexPath.row];
    }
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger count = [self.datasource numberOfBannersInBannerView:self];
    if (count == 0) return;
    
    NSInteger currentPage = 0;
    if (self.scrollDirection == KCBannerViewScrollDirectionHorizontal) {
        
        
       currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % count;
    }else {
        
        currentPage = (NSInteger)(scrollView.contentOffset.y / scrollView.bounds.size.height + 0.5) % count;
    }
    self.pageControl.currentPage = currentPage;
}

#pragma mark -公共方法
- (void)reloadData
{
    [self removeTimer];
    [self addTimer];
    
    self.pageControl.numberOfPages = [self.datasource numberOfBannersInBannerView:self];
}

- (BOOL)isRepeat
{
    return [self.datasource numberOfBannersInBannerView:self] <= 1 ? NO : _repeat;
}

- (void)setDatasource:(id<KCBannerViewDatasource>)datasource
{
    _datasource = datasource;
    
    [self reloadData];
    
}

- (void)setScrollDirection:(KCBannerViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    KCBannerViewLayout *layout = (KCBannerViewLayout *)self.collectionView.collectionViewLayout;
    
    layout.scrollDirection = (UICollectionViewScrollDirection)scrollDirection;
}

#pragma mark -懒加载
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        
    }
    return _pageControl;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        
        KCBannerViewLayout *layout = [[KCBannerViewLayout alloc] init];
        layout.scrollDirection = (UICollectionViewScrollDirection)self.scrollDirection;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [_collectionView registerClass:[KCBannerCell class] forCellWithReuseIdentifier:KCBannerCellReuseID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        
        
    }
    return _collectionView;
}



@end
