//
//  NetRequest.h
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequest : NSObject

// 请求天气信息
+ (void)requestWeatherWithCity:(NSString *)city success:(void (^)(id responseDic))success;

@end


#pragma mark - 创建AFNeetWorking单利类

@interface AFNetWorkingSingleton : NSObject

+ (AFHTTPRequestOperationManager *)sharedNetManger;

@end
