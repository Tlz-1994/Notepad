//
//  DeployDelegate.m
//  NoteRecord
//
//  Created by stefanie on 16/4/1.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "DeployDelegate.h"
#import "LZViewController.h"
#import "LZLoadViewController.h"
#import <AMapFoundation/AMapFoundationKit/AMapServices.h>

@implementation DeployDelegate

// 创建首页控制器
+ (void)deployMainViewController:(UIWindow *)window {
    if ((BOOL)[LZNSUserDefaults valueForKey:LOAD_STATUS] == YES) {
        LZViewController *mainVC = [[LZViewController alloc] init];
        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:mainVC];
        window.rootViewController = nav;
    }
    else {
        LZLoadViewController *mainVC = [[LZLoadViewController alloc] init];
        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:mainVC];
        window.rootViewController = nav;
    }
}

// 高德
+ (void)settingIBS {
    [AMapServices sharedServices].apiKey = (NSString *)GAODEAPI_KEY;
//    [AMapSearchServices sharedServices].apiKey = (NSString *)GAODEAPI_KEY;
//    [AMapLocationServices sharedServices].apiKey = (NSString *)GAODEAPI_KEY;
}

@end
