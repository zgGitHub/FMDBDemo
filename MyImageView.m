//
//  MyImageView.m
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "MyImageView.h"

@interface MyImageView ()

@property (nonatomic,weak) id target;//弱引用

@property (nonatomic,assign) SEL action;
@end

@implementation MyImageView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

//触摸 离开屏幕触发
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //委托 target 执行 action
    if ([self.target respondsToSelector:self.action]) {
        //把自己传过去
        [self.target performSelector:self.action withObject:self];
    }else{
        NSLog(@"没有实现方法");
    }
}
#pragma clang diagnostic pop


- (void)addTarget:(id)target action:(SEL)action {
    //图片默认是不能和用户交互的
    //1.先打开用户交互
    self.userInteractionEnabled = YES;
    //保存target action
    //触摸图片的时候才执行 target ->action;
    self.target = target;
    self.action = action;
}

@end







