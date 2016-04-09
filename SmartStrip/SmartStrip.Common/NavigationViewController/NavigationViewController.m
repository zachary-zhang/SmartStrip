//
//  NavigationViewController.m
//  smarthome
//
//  Created by john on 15/8/11.
//  Copyright (c) 2015年 张摇奖. All rights reserved.
//

#import "NavigationViewController.h"


@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton

{
    self.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"controllvc_backitem"] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
    barButton.tintColor = [UIColor whiteColor]; 
    return barButton;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
