//
//  DBManager.h
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 一个app 中 经常需要共享一些数据，需要保存到 本地数据库
 比如 收藏记录 下载记录 浏览记录等等 多个界面需要共享同一个数据库
 我们需要把这个数据库管理 设计成单例
 //这个类要操作数据库 创建数据库 增删改查数据
 
 */
#import "StudentModel.h"

@interface DBManager : NSObject
//非标准单例
//一般以 default / shared 开头
+ (instancetype)defaultManager;
//增加数据
- (void)insertModel:(StudentModel *)stu;
//删除
- (void)deleteModelWithUid:(NSString *)uid;
//修改数据
- (void)updateModelWithUid:(NSString *)uid newModel:(StudentModel*)newModel;
//查找 所有的数据
- (NSArray *)fetchAllData;


@end










