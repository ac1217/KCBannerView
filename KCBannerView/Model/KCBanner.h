//
//  KCBanner.h
//  无线循环图片轮播器demo
//
//  Created by xiliedu on 15/8/28.
//  Copyright (c) 2015年 xiliedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCBanner : NSObject

@property (nonatomic, strong) NSURL *picUrl;
@property (nonatomic, strong) UIImage *pic;

// 标题
@property (nonatomic, copy) NSString *title;

@end
