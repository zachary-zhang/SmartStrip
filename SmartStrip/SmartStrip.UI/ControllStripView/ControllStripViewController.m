//
//  ControllStripViewController.m
//  SmartStrip
//
//  Created by john on 16/1/8.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "ControllStripViewController.h"
#import "TimingViewController.h"
#import "ZCAudioTool.h"



@interface ControllStripViewController ()
{
    UIButton *switchBtn;
    UIImageView *backgroundview;
    UIImageView *iconImageView;
    UIButton *timingBtn;
    UIButton *electricityBtn;
    int index;
    WanManager *zWanManager;
    UILabel *remarkLabel;
    
    UIImage *zOnSwitchImage ;
    UIImage *zOffSwitchImage;
    UIImage *zTimingImage ;
    UIImage *zOffTimingImage ;
    UIImage *zElectrityImage ;
    UIImage *zOffElectrityImage ;
}
@end

@implementation ControllStripViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:_switchState==0?@"navi_back":@"navi_black"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateControllStripView];

}
/**
 *  界面
 */
-(void)updateControllStripView
{
    zOnSwitchImage = [UIImage imageNamed:@"controllvc_on"];
    zOffSwitchImage = [UIImage imageNamed:@"controllvc_off"];
    zTimingImage = [UIImage imageNamed:@"controllvc_onlock"];
    zOffTimingImage = [UIImage imageNamed:@"controllvc_offlock"];
    zElectrityImage = [UIImage imageNamed:@"controllvc_onelectrity"];
    zOffElectrityImage = [UIImage imageNamed:@"controllvc_offelectricity"];
    
    backgroundview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundview];
    [self.navigationController.navigationBar setShadowImage:[self imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.bounds.size.width, 3)]]; //隐藏导航栏线
    self.title = @"插座1";
    zSelf(weakSelf);
    
    iconImageView = [[UIImageView alloc] init];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zScreenWidth*2/5, zScreenWidth*2/5));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(zScreenHeightHaveNavi/16);
    }];
    
    remarkLabel = [[UILabel alloc]init];
    remarkLabel.textColor = [UIColor whiteColor];
    remarkLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remarkLabel];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zScreenWidth, 20));
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(5);
    }];

    switchBtn = [[UIButton alloc]init];
    [self.view addSubview:switchBtn];
    /**
     *  播放声音

     */
    [switchBtn addTarget:self action:@selector(playTock) forControlEvents:UIControlEventTouchDown];
    [switchBtn addTarget:self action:@selector(switchStrip:) forControlEvents:UIControlEventTouchUpInside];
    
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zOnSwitchImage.size.width*4/5, zOnSwitchImage.size.height*4/5));
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(-10);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-100);
    }];
    
    timingBtn = [[UIButton alloc]init];
    [timingBtn addTarget:self action:@selector(gotoTimingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timingBtn];
    [timingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(zTimingImage.size.width*4/5, zTimingImage.size.height*4/5));
            make.right.equalTo(switchBtn.mas_left).offset(zTimingImage.size.width*2/5);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-100);
    }];
    
    electricityBtn = [[UIButton alloc]init];
    [self.view addSubview:electricityBtn];
    [electricityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(zElectrityImage.size.width*4/5, zElectrityImage.size.height*4/5));
        make.left.equalTo(switchBtn.mas_right).offset(-5);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-100);
    }];
    [self updateLayout];
}
/**
 *  开关控制
 *
 *  @param sender
 */
-(void)switchStrip:(UIButton *)sender
{
    
//    zSelf(weakSelf);
    Byte byte[4] = {0x01,0x00,0x00,0x00};
    zWanManager = [WanManager shareWanManager];
    [zWanManager connetToHost];
    NSData *controlData = [ControlOlder generateContorlOlderWithCommandID:1 andParameterData:[NSData dataWithBytes:byte length:4]];
    [zWanManager controllStripWithData:controlData andIsControlOrder:YES];
//    [zWanManager keepSocketLinks];
    [zWanManager returnData:^(NSData *blockData) {
        
        if (blockData.length>14) {
            NSLog(@"成功-------%@",blockData);
            if (_switchState==0) {
                _switchState=1;
            }
            else if(_switchState==1){
                _switchState =0;
            }
            [self updateLayout];
        }

    } failure:^(NSString *blockString) {
        if ([blockString isEqualToString:@"TimeOut"]) {
//            if (IOS_VERSION<8.0) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"控制失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [av show];
//            }
//            else{
//            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"控制失败" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [ac addAction:cancelAction];
//            [weakSelf presentViewController:ac animated:YES completion:nil];
//            }
        }

    }];

}
/**
 *  更新icon颜色
 */
-(void)updateLayout
{
    backgroundview.image = [UIImage imageNamed:_switchState==0?@"controllvc_onbackground":@"controllvc_offbackground"];
    iconImageView.image = [UIImage imageNamed:_switchState==0? @"controllvc_onicon":@"controllvc_officon"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:_switchState==0?@"navi_back":@"navi_black"] forBarMetrics:UIBarMetricsDefault];
    if (_switchState==0) {
        [switchBtn setBackgroundImage:zOnSwitchImage forState:0];
        [timingBtn setBackgroundImage:zTimingImage forState:0];
        [electricityBtn setBackgroundImage:zElectrityImage forState:0];
         remarkLabel.text = @"插座电源已开启";
    }
    else if (_switchState==1) {
        [switchBtn setBackgroundImage:zOffSwitchImage forState:0];
        [timingBtn setBackgroundImage:zOffTimingImage forState:0];
        [electricityBtn setBackgroundImage:zOffElectrityImage forState:0];
         remarkLabel.text = @"插座电源已关闭";
    }
}

-(void)gotoTimingView
{
    TimingViewController *vc = [[TimingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  隐藏导航栏线条  
 *
 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(void)playTock
{
    ZCAudioTool *tool = [[ZCAudioTool alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
    [tool play];
}
@end
