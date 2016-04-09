//
//  PairingViewController.m
//  SmartStrip
//
//  Created by john on 16/1/8.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "PairingViewController.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "CommAnimationView.h"


@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>

@end


@implementation EspTouchDelegateImpl
-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);

}
@end

@interface PairingViewController ()
{
    UITextField *networkPasswordTF;
    UILabel *currentNetLabel;
    UIButton *isHidePasswordBtn;
    NSString *zCurrentNetwork;
    ESPTouchTask *_esptouchTask;
    BOOL isConfirmState;
    EspTouchDelegateImpl *_esptouchDelegate;
    NSCondition *_condition;
    UIButton *startPairingBtn;
    
    BALoadingView *loadView;
}
@end

@implementation PairingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /**
     *  更新是否修改WI-FI
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCurrentNetwork) name:EnterForeground object:nil];
}
-(void)updateCurrentNetwork
{
    [self updateCurrentLable];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updatePairingControllerUI];
    [self enableConfirmBtn];
    CommAnimationView *cv = [[CommAnimationView alloc]init];
    [cv showAnimationView];
}
-(void)updateCurrentLable
{
    zCurrentNetwork = [CurrentNetwork generateCurrentNetwork].length==0?@"未连接Wi-Fi":[CurrentNetwork generateCurrentNetwork];
    currentNetLabel.text =[NSString stringWithFormat:@"当前Wi-Fi: %@",zCurrentNetwork];
}
-(void)updatePairingControllerUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Wi-Fi 配对", @"Wi-Fi 配对");
    zSelf(weakSelf);
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"pairingvc_icon"];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zScreenWidth/3, zScreenWidth/3));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(zScreenHeightHaveNavi/16);
    }];
    
    currentNetLabel = [[UILabel alloc] init];
    currentNetLabel.textColor = [UIColor lightGrayColor];
    currentNetLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    currentNetLabel.textAlignment = NSTextAlignmentCenter;
    [self updateCurrentLable];
    [self.view addSubview:currentNetLabel];
    [currentNetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zScreenWidth, 20));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(10);
    }];
    
    UIButton *changeNetBtn = [[UIButton alloc] init];
    [changeNetBtn setTitle:NSLocalizedString(@"更换其它的Wi-Fi", @"更换其它的Wi-Fi") forState:0];
    changeNetBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [changeNetBtn addTarget:self action:@selector(changeCurrentNetwork) forControlEvents:UIControlEventTouchUpInside];
    [changeNetBtn setTitleColor:CommonBackgroundColor forState:0];
    [self.view addSubview:changeNetBtn];
    [changeNetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(currentNetLabel.mas_bottom).offset(8);
    }];
    
    networkPasswordTF = [[UITextField alloc]init];
    [networkPasswordTF setBackground:[UIImage imageNamed:@"pairingvc_inputbox"]];
    networkPasswordTF.placeholder=@"  请输入Wi-Fi密码";
    networkPasswordTF.secureTextEntry=YES;
    networkPasswordTF.delegate=self;
    networkPasswordTF.textAlignment = NSTextAlignmentCenter;
    [networkPasswordTF setValue:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKeyPath:@"_placeholderLabel.font"];
    [networkPasswordTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:networkPasswordTF];
    [networkPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-160);
        make.height.mas_equalTo(40);
    }];
    
    isHidePasswordBtn = [[UIButton alloc]init];
    [isHidePasswordBtn setBackgroundImage:[UIImage imageNamed:@"pairingvc_hide"] forState:UIControlStateNormal];
    [isHidePasswordBtn setBackgroundImage:[UIImage imageNamed:@"pairingvc_show"] forState:UIControlStateSelected];
    [  self.view addSubview:isHidePasswordBtn];
    [isHidePasswordBtn addTarget:self action:@selector(isHiddenOrShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    [isHidePasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(networkPasswordTF.mas_right).offset(-20);
        make.top.mas_equalTo(networkPasswordTF.mas_top).offset(5);
    }];
    
    startPairingBtn = [[UIButton alloc]init];
    [startPairingBtn setBackgroundImage:[UIImage imageNamed:@"pairingvc_inputbox"] forState:0];
//    [startPairingBtn setTitle:@"开始配对" forState:0];
//    [startPairingBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    [startPairingBtn addTarget:self action:@selector(startPairing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startPairingBtn];
    [startPairingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.equalTo(networkPasswordTF.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
/**
 *  是否显示密码
 */
-(void)isHiddenOrShowPassword:(UIButton *)sender
{
    isHidePasswordBtn.selected = !sender.selected;
    networkPasswordTF.secureTextEntry=!isHidePasswordBtn.selected;
}
/**
 *  跳转WiFi切换界面
 */
-(void)changeCurrentNetwork
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}
/**
 *  开始配对
 */
-(void)startPairing
{
    if (networkPasswordTF.text.length<2) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"Wi-Fi密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];

    }
    else{
        [self tapConfirmForResults];
    }
}
- (void) tapConfirmForResults
{
    // do confirm
    if (isConfirmState)
    {
//        [self._spinner startAnimating];
        [self enableCancelBtn];
        NSLog(@"ESPViewController do confirm action...");
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            // execute the task
            NSArray *esptouchResultArray = [self executeForResults];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self._spinner stopAnimating];
                [self enableConfirmBtn];
                
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                // check whether the task is cancelled and no results received
                if (!firstResult.isCancelled)
                {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                    }
                    
                    else
                    {
                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                    }
                }
                
            });
        });
    }
    // do cancel
    else
    {
//        [self._spinner stopAnimating];
        [self enableConfirmBtn];
        NSLog(@"ESPViewController do cancel action...");
        [self cancel];
    }
}

#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [_condition lock];
    zCurrentNetwork = [CurrentNetwork generateCurrentNetwork];
    NSString *apSsid = zCurrentNetwork;
    NSString *apPwd = networkPasswordTF.text;
    NSString *apBssid = [CurrentNetwork generateCurrentNetworkBSSID];
    int taskCount = 1;
    _esptouchTask =[[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    // set delegate
    [_esptouchTask setEsptouchDelegate:_esptouchDelegate];
    [_condition unlock];
    NSArray * esptouchResults = [_esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}

#pragma mark - the example of how to use executeForResult

- (ESPTouchResult *) executeForResult
{
    [_condition lock];
    NSString *apSsid = zCurrentNetwork;
    NSString *apPwd = networkPasswordTF.text;
    NSString *apBssid = [CurrentNetwork generateCurrentNetworkBSSID];
    _esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:NO];
    // set delegate
    [_esptouchTask setEsptouchDelegate:_esptouchDelegate];
    [_condition unlock];
    ESPTouchResult * esptouchResult = [_esptouchTask executeForResult];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResult);
    return esptouchResult;
}

-(void)enableCancelBtn
{
    isConfirmState = NO;
    [startPairingBtn setTitle:@"取消" forState:0];
    [startPairingBtn setTitleColor:[UIColor lightGrayColor] forState:0];
}
-(void)enableConfirmBtn
{
    isConfirmState = YES;
    [startPairingBtn setTitle:@"开始配对" forState:0];
    [startPairingBtn setTitleColor:CommonBackgroundColor forState:0];
}
- (void) cancel
{
    [_condition lock];
    if (_esptouchTask != nil)
    {
        [_esptouchTask interrupt];
    }
     [_condition unlock];
}

#pragma ESPTouchDelegate
-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
}
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [networkPasswordTF mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-keyboardHeight);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    zSelf(weakSelf);
    // 修改为以前的约束（距下边距160）
    [networkPasswordTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-160);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EnterForeground object:nil];

}
@end
