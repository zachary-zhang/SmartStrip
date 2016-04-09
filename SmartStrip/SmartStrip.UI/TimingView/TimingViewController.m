//
//  TimingViewController.m
//  SmartStrip
//
//  Created by john on 16/1/11.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "TimingViewController.h"
#import "AddLockViewController.h"

@interface TimingViewController ()
{
    NSMutableArray *timingList;
}
@end

@implementation TimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithDataSource];
    [self updateTimingViewUI];
    
}
-(void)initWithDataSource
{
    timingList = [NSMutableArray array];
    [timingList addObject:@1];    
}
-(void)updateTimingViewUI
{
    self.title = @"插座电源定时";
    self.view.backgroundColor = [UIColor whiteColor];
    _zTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, zScreenWidth, zScreenHeightHaveNavi-100)];
    _zTableView.tableFooterView = [[UIView alloc]init];
    _zTableView.rowHeight = 60;
    _zTableView.delegate = self;
    _zTableView.dataSource = self;
    [self.view addSubview:_zTableView];
    _zTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_zTableView.mj_header endRefreshing];
        });
    }];
    [_zTableView.mj_header beginRefreshing];
    _zTableView.mj_header.automaticallyChangeAlpha = YES;
    
    UIButton *addLockBtn = [[UIButton alloc] init];
    [addLockBtn setBackgroundImage:[UIImage imageNamed:@"timing_add"] forState:0];
    [self.view addSubview:addLockBtn];
    [addLockBtn addTarget:self action:@selector(addLock:) forControlEvents:UIControlEventTouchUpInside];
    zSelf(weakSelf);
    [addLockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-15);
    }];
}

-(void)addLock:(UIButton *)sender
{
    AddLockViewController *vc = [[AddLockViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewShowWitMsg:@"您未设置任何定时任务！" ifNecessaryForRowCount:timingList.count];
    return timingList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"mainvc_icon"];
    cell.textLabel.text = @"闹钟1";
    return cell;
}


@end
