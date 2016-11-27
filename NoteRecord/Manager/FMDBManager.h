//
//  FMDBManager.h
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class RecordModel;

@interface FMDBManager : NSObject

// 数据库管理的单例
+ (instancetype)manager;

// 添加一个用户
+ (BOOL)addUserWithUserModel:(UserModel *)model;

// 判断用户是否登录成功
+ (BOOL)judgeUserLoadSuccess:(UserModel *)model;

// 添加一条记录到数据库
+ (BOOL)addRecordWithRecordModel:(RecordModel *)model;

// 删除一条记录
+ (BOOL)deleteRecordWithRid:(NSInteger)rid;

// 查询用户的所有记录
+ (NSMutableArray *)searchUserAllRecordWithUid:(NSString *)uid;

@end
