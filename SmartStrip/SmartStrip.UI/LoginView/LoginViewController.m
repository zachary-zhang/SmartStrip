//
//  LoginViewController.m
//  SmartStrip
//
//  Created by john on 16/1/5.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "NavigationViewController.h"
#import "QRCodeReaderViewController.h"

@interface LoginViewController ()
{
    UIImageView *zLogoImageView;
    UITextField *userNameTF;
    UITextField *passwordTF;
    UIButton *loginBtn;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setNeedsStatusBarAppearanceUpdate];
    [self updateLoginViewControllerUI];
    [self initSSCheckBox];
    
}
/**
 *  加载界面
 */
-(void)updateLoginViewControllerUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    zSelf(weakSelf);
    
    UIImageView *zBackgroundImageView = [[UIImageView alloc]init];
    zBackgroundImageView.image = [UIImage imageNamed:@"login_background"];
    zBackgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:zBackgroundImageView];
    [zBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.view);
        make.center.equalTo(weakSelf.view);
    }];
    
    zLogoImageView = [[UIImageView alloc]init];
    zLogoImageView.image = [UIImage imageNamed:@"login_logo"];
    [zBackgroundImageView addSubview:zLogoImageView];
    [zLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zScreenWidth/3, zScreenWidth/3));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(60);
    }];
    
    userNameTF = [[UITextField alloc]init];
    userNameTF.delegate=self;
    userNameTF.textColor = [UIColor whiteColor];
    userNameTF.keyboardType = UIKeyboardTypeURL;
    userNameTF.textAlignment=NSTextAlignmentCenter;
    userNameTF.background=[UIImage imageNamed:@"login_username"];
    userNameTF.placeholder=@"请输入用户名/扫描";
    [userNameTF setValue:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKeyPath:@"_placeholderLabel.font"];
    [userNameTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:userNameTF];
    [userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(zLogoImageView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    UIButton *scanBtn = [[UIButton alloc]init];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"login_scan"] forState:0];
    [self.view addSubview:scanBtn];
    [scanBtn addTarget:self action:@selector(scanUserName) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(userNameTF.mas_right).offset(-20);
        make.top.mas_equalTo(userNameTF.mas_top).offset(5);
    }];
    
    passwordTF = [[UITextField alloc]init];
    passwordTF.textAlignment=NSTextAlignmentCenter;
    passwordTF.delegate=self;
    passwordTF.secureTextEntry=YES;
    passwordTF.textColor = [UIColor whiteColor];
    passwordTF.background=[UIImage imageNamed:@"login_password"];
    passwordTF.placeholder=@"输入密码";
    [passwordTF setValue:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKeyPath:@"_placeholderLabel.font"];
    [passwordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:passwordTF];
    
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(userNameTF.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    
    loginBtn = [[UIButton alloc]init];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:0];
    [loginBtn setTitle:@"登 录" forState:0];
    [loginBtn setTitleColor:CommonBackgroundColor forState:0];
    [loginBtn addTarget:self action:@selector(loginMianView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(passwordTF);
        make.top.mas_equalTo(passwordTF.mas_bottom).offset(70);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    checkRememberPWD = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(zScreenWidth/8, 230+zScreenWidth*2/5, 135, 50) style:4 checked:true];//初始化“记住密码”选框
    [checkRememberPWD setText:@"记住密码"];
    checkAutoLogin = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(zScreenWidth*7/8-120, 230+zScreenWidth*2/5, 120, 50) style:4 checked:false];//初始化“自动登陆”选框
    [checkAutoLogin setStateChangedTarget:self selector:@selector(checkAutoLoginChangedState:)];
    [checkAutoLogin setText:@"自动登录"];
    [self.view addSubview:checkAutoLogin];//添加 自动登陆 选框视图
    [self.view addSubview:checkRememberPWD];//添加 记住密码 选框视图
    [checkRememberPWD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135, 50));
        make.top.equalTo(passwordTF.mas_bottom).offset(20);
        make.left.equalTo(passwordTF.mas_left).offset(10);
    }];
    [checkAutoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 50));
        make.top.equalTo(checkRememberPWD);
        make.right.equalTo(passwordTF);
    }];
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *  加载复选框
 */
-(void)initSSCheckBox
{
    NSString * strIsAutoLogin = [Singlton readSettingsByKey:zAutoLogin];
    NSString * strIsRememberPWD = [Singlton readSettingsByKey:zRememberPWD];
    if ([Singlton isNOTStringNullOrWhitespace:strIsAutoLogin]) {
        checkAutoLogin.checked = [strIsAutoLogin isEqualToString:@"1"];
    }else{
        checkAutoLogin.checked = true;
    }
    
    if ([Singlton isNOTStringNullOrWhitespace:strIsRememberPWD]) {
        checkRememberPWD.checked = [strIsRememberPWD isEqualToString:@"1"];
    }else{
        checkRememberPWD.checked = true;
    }
    
    NSString * loginName = [Singlton readSettingsByKey:zLoginName];
    NSString * password = [Singlton readSettingsByKey:zPassword];
    if([Singlton isNOTStringNullOrWhitespace:loginName]){
        userNameTF.text = loginName;
    }else{
        userNameTF.text = @"";
    }
    if([Singlton isNOTStringNullOrWhitespace:password]){
        passwordTF.text = password;
    }else{
        passwordTF.text = @"";
    }
    if([strIsAutoLogin isEqualToString:@"1"]){
        [self loginMianView];
    }
}
- (void)checkAutoLoginChangedState:(SSCheckBoxView *)cbv
{
    if (cbv.checked) {
        checkRememberPWD.checked = true;
    }
}
/**
 *  扫描二维码
 */
-(void)scanUserName
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
            reader = [QRCodeReaderViewController new];
        });
        reader.delegate = self;
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}
-(void)loginMianView
{
    MainViewController *mainvc = [[MainViewController alloc] initWithStyle:0];
    NavigationViewController *navi = [[NavigationViewController alloc] initWithRootViewController:mainvc];
    navi.navigationBar.translucent = NO;
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        userNameTF.text=result;
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat bottomHeight = zScreenHeightNoNavi-passwordTF.frame.origin.y-passwordTF.frame.size.height;
    // 修改下边距约束
    if (bottomHeight<keyboardHeight) {
        // 更新约束
        [UIView animateWithDuration:keyboardDuration animations:^{
            self.view.frame = CGRectMake(0, -bottomHeight, zScreenWidth, zScreenHeightNoNavi);
        }];
    }

}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 修改为以前的约束（距下边距160）
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        self.view.frame = CGRectMake(0, 0, zScreenWidth, zScreenHeightNoNavi);
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
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
