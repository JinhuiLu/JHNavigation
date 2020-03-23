//
//  UINavigationController+JHNavigation.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JHNavigation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (JHNavigation)

/// 获取当前导航控制器（最上层VC的导航控制器）
+ (UINavigationController *)currentNavigationController;

@end

NS_ASSUME_NONNULL_END
