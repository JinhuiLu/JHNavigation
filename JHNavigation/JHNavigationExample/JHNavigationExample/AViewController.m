//
//  AViewController.m
//  JHNavigationExample
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "AViewController.h"
#import "JHNavigation.h"

@interface AViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn2;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"A页面";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, 300, 20);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    label.text = @"A页面";
    self.label = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.bounds = CGRectMake(0, 0, 200, 30);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y + 60);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"跳转到横屏带导航条A页面" forState:UIControlStateNormal];
    [btn setTintColor:UIColor.whiteColor];
    [btn addTarget:self action:@selector(jumpToAVC1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.btn = btn;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.bounds = CGRectMake(0, 0, 200, 30);
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y + 60);
    btn2.backgroundColor = [UIColor purpleColor];
    [btn2 setTitle:@"跳转到竖屏带导航条A页面" forState:UIControlStateNormal];
    [btn2 setTintColor:UIColor.whiteColor];
    [btn2 addTarget:self action:@selector(jumpToAVC2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    self.btn2 = btn2;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.label.center = CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f - 25);
    
    self.btn.center = CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f + 25);
    
    self.btn2.center = CGPointMake(self.view.bounds.size.width / 2.f, self.view.bounds.size.height / 2.f + 60);
}

- (void)jumpToAVC1 {
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusEnable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationLandscapeRight;
    aVc.jh_navigationBarStatus = JHNavigationBarStatusDefault;
    [self.navigationController pushViewController:aVc animated:YES];
}

- (void)jumpToAVC2 {
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusDisable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationPortrait;
    aVc.jh_navigationBarStatus = JHNavigationBarStatusDefault;
    [self.navigationController pushViewController:aVc animated:YES];
}

- (CGRect)jh_frameFromFullScreen {
    return CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2.f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2.f);
}

- (UIColor *)jh_containerBackgroundColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.3];
}


@end
