//
//  FMDBManager.m
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabase.h"
#import "UserModel.h"
#import "RecordModel.h"

@implementation FMDBManager
{
    FMDatabase *_dataBase;
}

+ (instancetype)manager {
    static FMDBManager *manager = nil;
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[FMDBManager alloc] init];
        });
    }
    return manager;
}

// 创建数据库
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataBase = [[FMDatabase alloc] initWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/record.db"]];
        NSString *sql1 = @"create table if not exists user (uid text primary key, psw text)";   // 创建用户表
        // 创建记录表
        NSString *sql2 = @"create table if not exists record (r_id integer primary key autoincrement, uid text, photoUrl text, message text, position text, place text, weather text, time text)";
        // 打开数据库
        [_dataBase open];
        [_dataBase setShouldCacheStatements:YES];
        // 执行语句, 创建表
        if ([_dataBase executeUpdate:sql1]) {
            LZLog(@"创建用户表成功");
        }
        else {
            LZLog(@"创建用户表失败");
        }
        if ([_dataBase executeUpdate:sql2]) {
            LZLog(@"创建记录表成功");
        }
        else {
            LZLog(@"创建记录表失败");
        }
    }
    return self;
}

// 添加一个用户
+ (BOOL)addUserWithUserModel:(UserModel *)model {
    return [[self manager] addUserWithUserModel:model];
}

- (BOOL)addUserWithUserModel:(UserModel *)model {
    NSString *sql = @"insert into user (uid, psw) values (?, ?)";
    BOOL ret = [_dataBase executeUpdate:sql, model.uid, model.psw];
    return ret;
}

// 判断用户是否登陆成功
+ (BOOL)judgeUserLoadSuccess:(UserModel *)model {
    return [[self manager] judgeUserLoadSuccess:model];
}

- (BOOL)judgeUserLoadSuccess:(UserModel *)model {
    NSString *sql = @"select * from user where uid = ? and psw = ?";
    FMResultSet *set = [_dataBase executeQuery:sql, model.uid, model.psw];
    if ([set next]) {
        return YES;
    }
    else {
        return NO;
    }
}


// 添加一条记录到数据库
+ (BOOL)addRecordWithRecordModel:(RecordModel *)model {
    return [[self manager] addRecordWithRecordModel:model];
}

- (BOOL)addRecordWithRecordModel:(RecordModel *)model {
    NSString *sql = @"insert into record (uid, photoUrl, message, position, place, weather, time) values (?, ?, ?, ?, ?, ?, ?)";
    BOOL ret = [_dataBase executeUpdate:sql, model.uid, model.photoUrl, model.message, model.position, model.place, model.weather, model.time];
    if (ret == YES) {
        LZLog(@"插入记录成功");
        if (ret) {
            AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提醒" andText:@"添加记录成功" andCancelButton:NO forAlertType:AlertSuccess];
            [alert show];
        }
        else {
            AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提醒" andText:@"添加记录失败" andCancelButton:NO forAlertType:AlertSuccess];
            [alert show];
        }
    }
    return ret;
}

// 删除一条记录
+ (BOOL)deleteRecordWithRid:(NSInteger)rid {
    return [[self manager] deleteRecordWithRid:rid];
}

- (BOOL)deleteRecordWithRid:(NSInteger)rid {
    // 如果有图片，删除
    NSString *deleteSql = @"select * from record where r_id = ?";
    FMResultSet *set = [_dataBase executeQuery:deleteSql, [NSString stringWithFormat:@"%zd", rid]];
    while ([set next]) {
        NSString *photoUrl = [set stringForColumn:@"photoUrl"];
        BOOL isok = [[NSFileManager defaultManager] removeItemAtPath:photoUrl error:nil];
        LZLog(@"照片删除%zd", isok);
    }
    NSString *sql = @"delete from record where r_id = ?";
    // 执行删除操作
    BOOL ret = [_dataBase executeUpdate:sql, [NSString stringWithFormat:@"%zd", rid]];
    
    return ret;
}

// 查询用户的所有记录
+ (NSArray *)searchUserAllRecordWithUid:(NSString *)uid {
    return [[self manager] searchUserAllRecordWithUid:uid];
}

- (NSMutableArray *)searchUserAllRecordWithUid:(NSString *)uid {
    NSString *sql = @"select * from record where uid = ? order by r_id desc";
    FMResultSet *set = [_dataBase executeQuery:sql, uid];
    
    NSMutableArray *arr = [NSMutableArray array];
    while ([set next]) {
        RecordModel *model = [[RecordModel alloc] init];
        model.r_id = [set intForColumn:@"r_id"];
        model.uid = [set stringForColumn:@"uid"];
        model.photoUrl = [FILE_PATH stringByAppendingPathComponent:[set stringForColumn:@"photoUrl"]];
        model.message = [set stringForColumn:@"message"];
        model.position = [set stringForColumn:@"position"];
        model.place = [set stringForColumn:@"place"];
        model.weather = [set stringForColumn:@"weather"];
        model.time = [set stringForColumn:@"time"];
        [arr addObject:model];
    }
    return arr;
}















- (void)dealloc {
    [_dataBase close];
}


@end
