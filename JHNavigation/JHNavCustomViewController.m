//
//  JHNavCustomViewController.m
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "JHNavCustomViewController.h"

#import "UINavigationController+JHNavigation.h"

@interface JHNavCustomViewController ()

@property (nonatomic, strong) UIViewController *childVC;

@property (nonatomic, assign) CGRect childFrame;

@end

@implementation JHNavCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHalfViewController)];
    
    [self.containerView addGestureRecognizer:gesture];
}

- (void)dismissHalfViewController {
    self.containerView.hidden = YES;
    [[UINavigationController currentNavigationController] popViewControllerAnimated:YES];
}

#pragma mark - public methods

- (void)addCustomChildViewController:(UIViewController *)childController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    self.childVC = childController;
    
    // 读取自定义的frame大小，默认为全屏
    if ([childController respondsToSelector:@selector(jh_frameFromFullScreen)]) {
        self.childFrame = [childController jh_frameFromFullScreen];
    } else {
        self.childFrame = [UIScreen mainScreen].bounds;
    }
    // 从半屏到半屏
    if ([self.lastNavigationController.topViewController isKindOfClass:[JHNavCustomViewController class]]) {

    } else { // 从全屏到半屏
        if ([childController respondsToSelector:@selector(jh_containerBackgroundColor)]) {
            self.containerView.backgroundColor = [childController jh_containerBackgroundColor];
        }
    }
    self.containerView.hidden = NO;
    
    [self addChildViewController:self.childVC];
    [self.view addSubview:self.childVC.view];
    
    if (animated) {
        self.childVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.childFrame.size.width, self.childFrame.size.height);
        [UIView animateWithDuration:0.3f animations:^{
            self.childVC.view.frame = self.childFrame;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        self.childVC.view.frame = self.childFrame;
        if (completion) {
            completion();
        }
    }
}

- (void)removeCustomChildViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    
    //如果处于编辑状态先结束编辑
    [self.childVC.view endEditing:animated];
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.childVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.childFrame.size.width, self.childFrame.size.height);
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        if (completion) {
            completion();
        }
    }
}

@end
