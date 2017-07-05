//
//  KCBannerCell.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "KCBannerCell.h"
#import "KCBanner.h"
#import "YYWebImage.h"

extern NSString *const KCBannerViewContentOffsetDicChangeNotification;
extern NSString *const KCBannerViewDicChangeFrameKey;

NSString *const KCBannerCellReuseID = @"KCBannerCell";

@interface KCBannerCell (){
    id <KCBannerProtocol> _banner;
    
}
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation KCBannerCell

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    }
    
    return _titleLabel;
}

#pragma mark -Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.imageView];
        
        
        [self.contentView addSubview:self.titleLabel];
        
        
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

- (void)setBanner:(id<KCBannerProtocol>)banner placeholder:(UIImage *)placeholder
{
    _banner = banner;
    
    if ([banner.imageResource isKindOfClass:[UIImage class]]) {
        
        self.imageView.image = banner.imageResource;
        
    }else if ([banner.imageResource isKindOfClass:[NSURL class]]) {
        [self.imageView yy_setImageWithURL:banner.imageResource placeholder:placeholder];
        
    }else if([banner.imageResource isKindOfClass:[NSString class]]) {
        
        if ([banner.imageResource hasPrefix:@"http"]) {
            
            [self.imageView yy_setImageWithURL:[NSURL URLWithString:banner.imageResource] placeholder:placeholder];
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
