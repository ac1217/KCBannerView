//
//  UIImageView+SDWebImage.m
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDWebImage)


- (void)imageWithUrl:(NSURL *)url
{
    [self sd_setImageWithURL:url];
}

@end
