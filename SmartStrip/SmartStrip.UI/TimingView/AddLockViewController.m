//
//  AddLockViewController.m
//  SmartStrip
//
//  Created by john on 16/1/11.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "AddLockViewController.h"
#import "CommDatePickView.h"
#import "CommMultiselectView.h"
#import "QHHead.h"
@interface AddLockViewController ()<CommDatePickViewDelegate,CommMultiselectViewDelegate>
{
    NSArray *cellArray;
    CommDatePickView *zCommDatePickView;
    NSDateFormatter *dateFormatter;
}

@end

@implementation AddLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [self updateAddLockViewUI];
}
-(void)updateAddLockViewUI
{
    self.title = @"设置定时";
    cellArray = @[@"重复",@"开启",@"关闭"];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveTheLock)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =right;
    
    _zTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, zScreenWidth, zScreenHeightHaveNavi-100)];
    _zTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _zTableView.tableFooterView = [[UIView alloc]init];
    _zTableView.scrollEnabled = NO;
    _zTableView.rowHeight = 60;
    _zTableView.delegate = self;
    _zTableView.dataSource = self;
    [self.view addSubview:_zTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = CommonBackgroundColor;
        cell.detailTextLabel.textColor = CommonBackgroundColor;
    }
    NSDate *nowDate = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:nowDate];
    cell.textLabel.text = cellArray[indexPath.row];
    cell.detailTextLabel.text = indexPath.row==0?@"执行一次": dateString;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CommMultiselectView *cv = [[CommMultiselectView alloc]init];
        cv.delegate=self;
        [cv showWithTag:1];
    }
    else{
        [self showDatePickViewWithRow:indexPath.row];
    }
    
}
-(void)showDatePickViewWithRow:(NSInteger )row;
{
    if (!zCommDatePickView) {
        zCommDatePickView = [[CommDatePickView alloc] init];
        zCommDatePickView.delagate = self;
    }
    zCommDatePickView.tag = row;
    [zCommDatePickView showWithTag:1];
}
/**
 *  时间选择器
 *
 */
- (void)didPickDataWithDate:(NSDate *)date andTag:(int)tag {
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    UITableViewCell *cell= [_zTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:zCommDatePickView.tag inSection:0]];
    cell.detailTextLabel.text  =dateString;
}
/**
 *  周期选择
 */
-(void)didSelectObjectWithArray:(NSArray *)selectArray andTag:(int)tag
{
    UITableViewCell *cell= [_zTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [selectArray componentsJoinedByString:@"、"];
}
-(void)saveTheLock
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
