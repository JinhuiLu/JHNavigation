//
//  UIViewController+JHNavigation_Private.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JHNavigation.h"

NS_ASSUME_NONNULL_BEGIN

@class JHNavigationConfig;

@interface UIViewController (JHNavigation_Private)

/// 缓存导航配置
@property (nonatomic, strong) JHNavigationConfig *jh_navigationConfig;

/// 读取导航配置中，页面旋转和导航条显示相关配置
- (void)jh_loadNavigationConfig;

/// 读取导航配置中，页面跳转相关配置
- (void)jh_loadNavigationSkipConfig;

/// 当前 view controller
+ (UIViewController *)jh_currentVC;

@end

@interface JHNavigationConfig : NSObject

/// 导航条显示状态
@property (nonatomic, assign) JHNavigationBarStatus navigationBarStatus;

/// 页面显示方式
@property (nonatomic, assign) JHScreenStyle screenStyle;

/// 页面旋转状态
@property (nonatomic, assign) JHAutorotateStatus autorotateStatus;

/// 页面默认方向
@property (nonatomic, assign) JHInterfaceOrientation interfaceOrientation;

/// 页面支持的方向
@property (nonatomic, assign) JHInterfaceOrientationMask interfaceOrientationMask;

/// Push风格
@property (nonatomic, assign) JHNavigationTransitionStyle pushStyle;

/// Pop风格
@property (nonatomic, assign) JHNavigationTransitionStyle popStyle;

/// 触发跳过pop状态
@property (nonatomic, assign) JHNeedTriggerSkipAtPopStatus needTriggerSkipAtPopStatus;

/// 跳过pop状态
@property (nonatomic, assign) JHNeedSkipPopStatus needSkipPopStatus;

@end

NS_ASSUME_NONNULL_END
