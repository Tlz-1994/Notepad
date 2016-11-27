//
//  RecordModel.h
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (nonatomic, assign) NSInteger r_id;  // 记录的id  唯一的
@property (nonatomic, copy) NSString *uid;   // 记录对应的用户id
@property (nonatomic, copy) NSString *photoUrl;  // 照片保存在沙盒的路径
@property (nonatomic, copy) NSString *message;   // 记录的文字信息
@property (nonatomic, copy) NSString *position;  // 记录的经纬度
@property (nonatomic, copy) NSString *place;     // 记录的地点
@property (nonatomic, copy) NSString *weather;   // 记录的天气情况
@property (nonatomic, copy) NSString *time;      // 记录的时间 使用时间戳

@end
