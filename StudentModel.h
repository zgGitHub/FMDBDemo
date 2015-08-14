//
//  StudentModel.h
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic,strong) NSData *imageData;
@end




