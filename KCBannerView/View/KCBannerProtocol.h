//
//  KCBannerProtocol.h
//  KCBannerViewDemo
//
//  Created by zhangweiwei on 2016/11/16.
//  Copyright © 2016年 Erica. All rights reserved.
//

@protocol KCBannerProtocol <NSObject>

/*kind of UIImage , url or imageNamed*/
@property (nonatomic, strong, readonly) id imageResource;

@optional
@property (nonatomic, copy, readonly) NSString *desc;
/*kind of UIImage or imageNamed*/
@property (nonatomic, strong, readonly) id placeholderImageResource;


@end
