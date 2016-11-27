//
//  DeployDelegate.h
//  NoteRecord
//
//  Created by stefanie on 16/4/1.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeployDelegate : NSObject

// 创建首页控制器
+ (void)deployMainViewController:(UIWindow *)window;

// 配置高德
+ (void)settingIBS;

@end
