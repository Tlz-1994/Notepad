//
//  PersonalViewController.m
//  NoteRecord
//
//  Created by stefanie on 16/4/1.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "PersonalViewController.h"
#import "LZLoadViewController.h"
#import "PersonalRecordVC.h"

@interface PersonalViewController ()
{
    UIButton *_logoutBtn;           // 退出登录按钮
    UIButton *_recordBtn;           // 进入个人记录按钮
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

#pragma mark - 创建UI
- (void)loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建背景视图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"launchbg.jpeg"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 40, 34, 34);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight/2.0-35, kWidth, 50)];
    userLabel.text = [LZNSUserDefaults valueForKey:USERID];
    userLabel.textColor = LZColor(255, 239, 213);
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:userLabel];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordBtn.frame = CGRectMake(0, 0, 105, 50);
    _recordBtn.centerX = kWidth/2.0;
    _recordBtn.y = kHeight/2.0-35+60;
    _recordBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_recordBtn setTitle:@"个人记录" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:LZColor(51, 51, 51) forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:_recordBtn];
    
    [_recordBtn addTarget:self action:@selector(viewHistiryRecord) forControlEvents:UIControlEventTouchUpInside];
    
    
    _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logoutBtn.frame = CGRectMake(0, 0, 105, 50);
    _logoutBtn.centerX = kWidth/2.0;
    _logoutBtn.y = CGRectGetMaxY(_recordBtn.frame)+40;
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:LZColor(51, 51, 51) forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:_logoutBtn];
    
    [_logoutBtn addTarget:self action:@selector(logoutApplication) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 查看历史
- (void)viewHistiryRecord {
    PersonalRecordVC *personalVC = [[PersonalRecordVC alloc] init];
    [self presentViewController:personalVC animated:YES completion:nil];
}

#pragma mark - 返回事件
- (void)backAction {
    [self.lcNavigationController popViewController];
}

#pragma mark -退出登录
- (void)logoutApplication {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    // 清理登录状态
    [LZNSUserDefaults removeObjectForKey:LOAD_STATUS];
    [LZNSUserDefaults synchronize];
    
    LZLoadViewController *mainVC = [[LZLoadViewController alloc] init];
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:mainVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
