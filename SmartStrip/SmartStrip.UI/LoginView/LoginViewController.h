//
//  LoginViewController.h
//  SmartStrip
//
//  Created by john on 16/1/5.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "SSCheckBoxView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,QRCodeReaderDelegate>
{
    SSCheckBoxView * checkRememberPWD;//记住密码选框
    SSCheckBoxView * checkAutoLogin;  //自动登陆选框
}
@end
