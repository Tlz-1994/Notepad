//
//  NetRequest.m
//  NoteRecord
//
//  Created by stefanie on 16/4/2.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

// 请求天气信息
+ (void)requestWeatherWithCity:(NSString *)city success:(void (^)(id))success {
    if (!city) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFNetWorkingSingleton sharedNetManger];
    [manager GET:WEATHER_URL parameters:@{@"cityname": city} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        LZLog(@"%@", error.description);
    }];
}

@end


@implementation AFNetWorkingSingleton

+ (AFHTTPRequestOperationManager *)sharedNetManger {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置相应内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"apikey"];
    return manager;
}

@end