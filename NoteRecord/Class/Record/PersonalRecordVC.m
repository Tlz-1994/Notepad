//
//  PersonalViewController.m
//  NoteRecord
//
//  Created by stefanie on 16/4/16.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "PersonalRecordVC.h"
#import "RecordModel.h"
#import "FMDBManager.h"
#import "RecordCell.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

@interface PersonalRecordVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *blankImageView;

@end

@implementation PersonalRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDatasource];
    [self loadUI];
    [self loadTableView];
}

// 初始化空白页
- (UIImageView *)blankImageView {
    if (!_blankImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 64, 64)];
        imageView.center = self.view.center;
        imageView.image = [UIImage imageNamed:@"blank"];
        _blankImageView = imageView;
    }
    return _blankImageView;
}

- (void)loadDatasource {
    NSMutableArray *arr = [FMDBManager searchUserAllRecordWithUid:[LZNSUserDefaults valueForKey:USERID]];
    self.datasource = [arr mutableCopy];
}

- (void)loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"whiteReturn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 40)];
    titleLable.centerX = kWidth/2.0;
    titleLable.text = @"记录中心";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    [navView addSubview:titleLable];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[RecordCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.datasource.count == 0) {
        self.blankImageView.hidden = NO;
        [self.view addSubview:self.blankImageView];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.blankImageView.hidden = YES;
    }
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    RecordModel *model = self.datasource[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    RecordModel *model = self.datasource[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RecordCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}


#pragma mark - 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordModel *model = self.datasource[indexPath.section];
    [self.datasource removeObjectAtIndex:indexPath.section];
//    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
    [FMDBManager deleteRecordWithRid:model.r_id];
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
