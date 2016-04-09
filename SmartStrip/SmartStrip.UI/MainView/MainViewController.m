//
//  MainViewController.m
//  SmartStrip
//
//  Created by john on 16/1/9.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "MainViewController.h"
#import "PairingViewController.h"
#import "ControllStripViewController.h"

@interface MainViewController ()
{
    NSMutableArray *stripArray;//实际一个帐号只有一个插座
}
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_back"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self updateMainViewUI];
    
}
-(void)updateMainViewUI
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.title = NSLocalizedString(@"首页", @"mainvc");
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainvc_rightbtn"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPairingViewController)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =right;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 100;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); 更改分割线的位置
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
             });
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}
-(void)initWithData
{
    stripArray = [NSMutableArray array];
    stripArray =[DBManager selecStrip];
    
}
-(void)gotoPairingViewController
{
    PairingViewController *vc = [[PairingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [tableView tableViewShowWitMsg:@"没有添加的插座" ifNecessaryForRowCount:stripArray.count];
//    return stripArray.count;
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.imageView.image = [UIImage imageNamed:@"mainvc_icon"];
    cell.textLabel.text = @"插座1";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControllStripViewController *vc = [[ControllStripViewController alloc] init];
    vc.switchState = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
