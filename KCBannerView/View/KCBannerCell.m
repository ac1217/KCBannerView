//
//  KCBannerCell.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "KCBannerCell.h"
#import "KCBanner.h"
#import "UIImageView+WebCache.h"


extern NSString *const KCBannerViewContentOffsetDicChangeNotification;
extern NSString *const KCBannerViewDicChangeFrameKey;

NSString *const KCBannerCellReuseID = @"KCBannerCell";

@interface KCBannerCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation KCBannerCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:KCBannerViewContentOffsetDicChangeNotification object:nil];
        
    }
    return self;
}

- (void)frameDidChange:(NSNotification *)note
{
    CGRect frame = [note.userInfo[KCBannerViewDicChangeFrameKey] CGRectValue];
    self.imageView.frame = frame;
    CGRect labelF = self.titleLabel.frame;
    labelF.origin.y = self.imageView.frame.origin.y;
    self.titleLabel.frame = labelF;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    
    CGFloat titleY = 0;
    CGFloat titleH = 30;
    
    if (self.descPosition == KCBannerCellDescPositionBottom) {
        titleY = self.contentView.frame.size.height - titleH;
    }
    
    self.titleLabel.frame = CGRectMake(0, titleY, self.contentView.frame.size.width, titleH);
}

- (void)setBanner:(id<KCBannerProtocol>)banner
{
    _banner = banner;
    
    UIImage *placeholderImage = nil;
    
    if ([banner respondsToSelector:@selector(placeholderImageResource)]) {
        
        if ([banner.placeholderImageResource isKindOfClass:[NSString class]]) {
            placeholderImage = [UIImage imageNamed:banner.placeholderImageResource];
        }else {
            placeholderImage = banner.placeholderImageResource;
        }
        
    }
    
    
    if ([banner.imageResource isKindOfClass:[UIImage class]]) {
        
        self.imageView.image = banner.imageResource;
        
    }else if ([banner.imageResource isKindOfClass:[NSURL class]]) {
        
        [self.imageView sd_setImageWithURL:banner.imageResource placeholderImage:placeholderImage];
        
    }else if([banner.imageResource isKindOfClass:[NSString class]]) {
        
        if ([banner.imageResource hasPrefix:@"http"]) {
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:banner.imageResource] placeholderImage:placeholderImage];
        }else {
            self.imageView.image = [UIImage imageNamed:banner.imageResource];
        }
        
    }else {
        self.imageView.image = nil;
    }
    
    
    if ([banner respondsToSelector:@selector(desc)]) {
        
        if (banner.desc.length) {
            
            self.titleLabel.hidden = NO;
            
            self.titleLabel.text = banner.desc;
            
        }else {
            
            self.titleLabel.hidden = YES;
        }
        
        
    }else {
        
        self.titleLabel.hidden = YES;
    }
    
    
}


@end
