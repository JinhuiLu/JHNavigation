//
//  HNavCustomViewController.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 承载自定义展示页面的VC
@interface JHNavCustomViewController : UIViewController

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UINavigationController *lastNavigationController;

- (void)addCustomChildViewController:(UIViewController *)childController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

- (void)removeCustomChildViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
