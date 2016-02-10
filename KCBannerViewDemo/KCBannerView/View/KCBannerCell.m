//
//  KCBannerCell.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "KCBannerCell.h"
#import "KCBanner.h"
#import "UIImageView+SDWebImage.h"
@interface KCBannerCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation KCBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, 30);
}

- (void)setBanner:(id<KCBannerProtocol>)banner
{
    _banner = banner;
    
    if ([banner pic]) {
        
        self.imageView.image = [banner pic];
        
    }else {
        
        [self.imageView imageWithUrl:[banner picUrl]];
        
    }
    
    if ([banner title].length) {
        self.titleLabel.hidden = NO;
        self.titleLabel.text = [banner title];
    }else {
        
        self.titleLabel.hidden = YES;
    }
    
}


@end
