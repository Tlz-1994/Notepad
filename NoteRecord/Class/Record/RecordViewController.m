//
//  RecordViewController.m
//  NoteRecord
//
//  Created by stefanie on 16/4/14.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

static NSString *TextIdentifiers = @"TextViewCell";
static NSString *CustomIdentifiers = @"CustomIdentifiers";

#import "RecordViewController.h"
#import "RecordModel.h"
#import "TextViewCell.h"
#import "CustomCell.h"
#import "FMDBManager.h"

#import "UIView+SDAutoLayout.h"

@interface RecordViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titles;
    NSArray *_images;
    NSArray *_details;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDatasource];
    [self loadUI];
    [self loadTableView];
    
}

- (void)loadDatasource {
    _titles = @[@"经纬度", @"位置", @"天气"];
    _images = @[@"location", @"position", @"weather"];
    _details = @[self.recordMoedl.position, self.recordMoedl.place, self.recordMoedl.weather];
}

#pragma mark - 创建UI
- (void)loadUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [self.view addSubview:navView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navView addSubview:leftBtn];
    leftBtn.frame = CGRectMake(5, 35, 50, 20);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navView addSubview:rightBtn];
    rightBtn.frame = CGRectMake(kWidth-55, 35, 50, 20);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
}

// 取消事件
- (void)cancleAction {
    // 删除保存的照片
    [[NSFileManager defaultManager] removeItemAtPath:self.recordMoedl.photoUrl error:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [LZNSUserDefaults removeObjectForKey:MESSAGE_SEND];
}

// 发送保存事件
- (void)sendAction {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFACTION_SEND object:nil];\
    self.recordMoedl.message = [LZNSUserDefaults valueForKey:MESSAGE_SEND];
    if (!self.recordMoedl.message || self.recordMoedl.message.length == 0) {
        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提醒" andText:@"写点什么纪念一下吧" andCancelButton:NO forAlertType:AlertInfo];
        [alert show];
    }
    else {
        // 将记录保存到数据库
        [FMDBManager addRecordWithRecordModel:self.recordMoedl];
        [self dismissViewControllerAnimated:YES completion:nil];
        [LZNSUserDefaults removeObjectForKey:MESSAGE_SEND];
    }
}

#pragma mark - 创建tableView
- (void)loadTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[TextViewCell class] forCellReuseIdentifier:TextIdentifiers];
    [tableView registerClass:[CustomCell class] forCellReuseIdentifier:CustomIdentifiers];
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.recordMoedl.photoUrl? 190 : 100;
    }
    else {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextIdentifiers];
        cell.recordModel = self.recordMoedl;
        return cell;
    }
    else {
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomIdentifiers];
        cell.imageView.image = [UIImage imageNamed:_images[indexPath.row-1]];
        cell.textLabel.text = _titles[indexPath.row-1];
        cell.detailTextLabel.text = _details[indexPath.row-1];
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
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
