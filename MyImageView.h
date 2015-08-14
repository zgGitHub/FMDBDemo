//
//  MyImageView.h
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView
//给 图片增加一个点击事件
- (void)addTarget:(id)target action:(SEL)action;

@end
