//
//  KCPictureRepeatView.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "KCBannerView.h"
#import "KCBannerCell.h"
#import "YYWebImage.h"

NSString *const KCBannerViewContentOffsetDicChangeNotification = @"KCBannerViewContentOffsetDicChangeNotification";
NSString *const KCBannerViewDicChangeFrameKey = @"KCBannerViewDicChangeFrameKey";

static const NSInteger KCMaxSectionCount = 10000;

@interface KCBannerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    UIPageControl *_pageControl;
    BOOL _repeat;
    UIImageView *_emptyImageView;
}


@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, assign) CGRect changeFrame;


@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation KCBannerView


- (void)dealloc
{
    [self removeTimer];
}

#pragma mark -Private Method

- (void)addTimer
{
    if (!self.isRepeat) return;
    
    [self removeTimer];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_SEC);
    
    //间隔时间
    uint64_t interval = self.timeInterval * NSEC_PER_SEC;
    
    dispatch_source_set_timer(timer, start, interval, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        [weakSelf nextPage];
    });

    dispatch_resume(timer);
    self.timer = timer;
    
}

- (void)removeTimer
{

    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    
}

- (void)nextPage
{
    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.lastObject;
    
    NSInteger count = self.pageControl.numberOfPages;
    
    NSInteger item = KCMaxSectionCount * count / 2 + indexPath.item % count;
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item + 1 inSection:0];
    
    UICollectionViewScrollPosition scrollPosition = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionCenteredVertically;
    
    [self.collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:scrollPosition animated:NO];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:scrollPosition animated:YES];
    
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
    _timeInterval = 5.0;
    _repeat = YES;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self addSubview:self.emptyImageView];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 15;
    
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    pageControlSize.height -= margin;
    
    
    CGFloat pageControlX = 0;
    CGFloat pageControlY = self.bounds.size.height - pageControlSize.height;
  
    if (self.pageControlPosition == KCBannerViewPageControlPositionRight) {
        
        pageControlX = self.bounds.size.width - margin - pageControlSize.width;
        
    }else if (self.pageControlPosition == KCBannerViewPageControlPositionLeft){
        
        pageControlX = margin;
        
    }else {
        
        pageControlX = (self.bounds.size.width - pageControlSize.width) * 0.5;
    }
    
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlSize.width, pageControlSize.height);
    
    self.collectionView.frame = self.bounds;
    
    self.changeFrame = self.bounds;
    
    self.emptyImageView.frame = self.bounds;
    
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count = self.pageControl.numberOfPages;

    self.emptyImageView.hidden = count != 0;
    
    return count > 1 ? count * KCMaxSectionCount : count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCBannerCellReuseID forIndexPath:indexPath];
    
    NSInteger index = indexPath.row % self.pageControl.numberOfPages;
    
    id imageResource = [self.dataSource bannerView:self imageResourceAtIndex:index];
    
    UIImage *placeholder = nil;
    
    if ([self.dataSource respondsToSelector:@selector(bannerView:placeholderImageAtIndex:)]) {
        placeholder = [self.dataSource bannerView:self placeholderImageAtIndex:index];
    }
    
    if ([imageResource isKindOfClass:[UIImage class]]) {
        
        cell.imageView.image = imageResource;
        
    }else if ([imageResource isKindOfClass:[NSURL class]]) {
        [cell.imageView yy_setImageWithURL:imageResource placeholder:placeholder];
        
    }else if([imageResource isKindOfClass:[NSString class]]) {
        
        if ([imageResource hasPrefix:@"http"]) {
            
            [cell.imageView yy_setImageWithURL:[NSURL URLWithString:imageResource] placeholder:placeholder];
        }else  {
            cell.imageView.image = [UIImage imageNamed:imageResource];
        }
        
    }else if ([imageResource isKindOfClass:[NSData class]]){
        cell.imageView.image = [UIImage imageWithData:imageResource];
        
    }else {
        
        cell.imageView.image = nil;
        
    }
    
    if ([self.dataSource respondsToSelector:@selector(bannerView:descriptionAttributedStringAtIndex:)]) {
        
        NSAttributedString *attr = [self.dataSource bannerView:self descriptionAttributedStringAtIndex:index];
        
        if (attr) {
            
            cell.titleLabel.attributedText = attr;
            cell.titleLabel.hidden = NO;
        }else {
            
            cell.titleLabel.hidden = YES;
        }
        
    }else if ([self.dataSource respondsToSelector:@selector(bannerView:descriptionStringAtIndex:)])
    {
        
        NSString *str = [self.dataSource bannerView:self descriptionStringAtIndex:index];
        
        if (str) {
            
            cell.titleLabel.text = str;
            cell.titleLabel.hidden = NO;
        }else {
            
            cell.titleLabel.hidden = YES;
        }
        
    }else {
        cell.titleLabel.hidden = YES;
    }
    
    
    cell.descPosition = (KCBannerCellDescPosition)self.descPosition;
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didTapImageAtIndex:)]) {
        [self.delegate bannerView:self didTapImageAtIndex:(indexPath.row % self.pageControl.numberOfPages)];
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
    NSInteger count = [self.dataSource numberOfBannersInBannerView:self];
    if (count == 0) return;
    
    NSInteger currentPage = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        
       currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % count;
        
    }else {
        
        currentPage = (NSInteger)(scrollView.contentOffset.y / scrollView.bounds.size.height + 0.5) % count;
    }
    self.pageControl.currentPage = currentPage;
}

#pragma mark -公共方法

- (void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    
    CGFloat offsetY = contentOffset.y;
    
    if (offsetY >= 0)
    {
        
        CGRect frame = self.changeFrame;
        frame.origin.y = offsetY * 0.5;
        self.changeFrame = frame;
        self.collectionView.clipsToBounds = YES;
        
    }else {
        
        CGFloat delta = 0.0f;
        CGRect rect = self.bounds;
        delta = fabs(MIN(0.0f, offsetY));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.changeFrame = rect;
        self.collectionView.clipsToBounds = NO;
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KCBannerViewContentOffsetDicChangeNotification object:nil userInfo:@{KCBannerViewDicChangeFrameKey : [NSValue valueWithCGRect:self.changeFrame]}];
    
    self.emptyImageView.frame = self.changeFrame;

}

- (void)reloadData
{
    
    self.pageControl.numberOfPages = [self.dataSource numberOfBannersInBannerView:self];
    
    [self.collectionView reloadData];
    
    [self setNeedsLayout];
    
    
    [self addTimer];
    
    if (self.pageControl.numberOfPages > 1 && self.pageControl.currentPage < self.pageControl.numberOfPages) {
        // contentSize不为0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:KCMaxSectionCount * self.pageControl.numberOfPages / 2 inSection:0];
                
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                    
                    
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                    
                }else {
                    
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
                
            
            
        });
    }
    
}


- (void)setPageControlPageImage:(UIImage *)pageImage
{
    
    [self.pageControl setValue:pageImage forKeyPath:@"pageImage"];
}

- (void)setPageControlCurrentPageImage:(UIImage *)currentPageImage
{
    [self.pageControl setValue:currentPageImage forKeyPath:@"currentPageImage"];
    
}

- (BOOL)isRepeat
{
    
    return self.pageControl.numberOfPages <= 1 ? NO : _repeat;
}

- (void)setRepeat:(BOOL)repeat
{
    _repeat = repeat;
    
    if (repeat) {
        [self addTimer];
    }else {
        [self removeTimer];
    }
    
}

- (void)setDataSource:(id<KCBannerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadData];
    
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    self.layout.scrollDirection = scrollDirection;
}

#pragma mark -懒加载
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
//        _pageControl addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>
    }
    return _pageControl;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        
        [_collectionView registerClass:[KCBannerCell class] forCellWithReuseIdentifier:KCBannerCellReuseID];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = [UIImageView new];
        _emptyImageView.contentMode = UIViewContentModeCenter;
        _emptyImageView.clipsToBounds = YES;
    }
    return _emptyImageView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}



@end
