//
//  DBManager.m
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager
{
    FMDatabase *_database;
}
//非标准单例
//一般以 default / shared 开头
+ (instancetype)defaultManager {
    static DBManager *manager = nil;
    @synchronized(self) {//同步 使线程同步 阻塞线程
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}
//初始化
- (instancetype)init {
    if (self = [super init]) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [docPath stringByAppendingPathComponent:@"studentData.sqlite"];
        _database = [[FMDatabase alloc] initWithPath:dataPath];
        if ([_database open]) {//如果数据库存在 那么 直接打开不存在先创建再打开
            //创建表
            [self createTable];
        }else{
            NSLog(@"open error:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
- (void)createTable {
    NSString *sql = @"CREATE TABLE if not exists stu (serial integer  Primary Key Autoincrement,uid Varchar(256),name Varchar(256),age integer,imageData blob)";
    //执行
    if (![_database executeUpdate:sql]) {
        //创建表失败
        NSLog(@"create table error:%@",_database.lastErrorMessage);
    }
}
//检测是否存在 uid 对应的数据
- (BOOL)isExistModelWithUid:(NSString *)uid {
    NSString *sql = @"select * from stu where uid = ?";
    FMResultSet *rs = [_database executeQuery:sql,uid];
    if ([rs next]) {//只有有记录表示 有数据
        return YES;
    }
    return NO;
}
//增加数据
- (void)insertModel:(StudentModel *)stu {
    if ([self isExistModelWithUid:stu.uid]) {
        NSLog(@"insert 数据已经存在");
        return;
    }
    NSString *sql = @"insert into stu(uid,name,age,imageData) values (?,?,?,?)";
    if (![_database executeUpdate:sql,stu.uid,stu.name,@(stu.age),stu.imageData]) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
//删除
- (void)deleteModelWithUid:(NSString *)uid {
    NSString *sql = @"delete from stu where uid = ?";
    if (![_database executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}
//修改数据
- (void)updateModelWithUid:(NSString *)uid newModel:(StudentModel*)newModel {
    NSString *sql = @"update stu set name = ?,age = ?,imageData = ? where uid = ?";
    if (![_database executeUpdate:sql,newModel.name,@(newModel.age),newModel.imageData,uid]) {
        NSLog(@"update error:%@",_database.lastErrorMessage);
    }
}
//查找 所有的数据
- (NSArray *)fetchAllData {
    NSString *sql = @"select * from stu";
    FMResultSet *rs = [_database executeQuery:sql];
    //创建空数组对象
    NSMutableArray *stuArr = [[NSMutableArray alloc] init];
    //遍历结果
    while ([rs next]) {
        StudentModel *model = [[StudentModel alloc] init];
        model.uid = [rs stringForColumn:@"uid"];
        model.name = [rs stringForColumn:@"name"];
        model.age = [rs intForColumn:@"age"];
        model.imageData = [rs dataForColumn:@"imageData"];
        //存放在 数据
        [stuArr addObject:model];
    }
    return stuArr ;//返回 查询之后的数组
}

@end





