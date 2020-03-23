//
//  UIViewController+JHNavigation.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHNavigationTypeDef.h"

NS_ASSUME_NONNULL_BEGIN

/*
 导航配置优先级 本分类导航配置 > 系统导航配置
*/
@interface UIViewController (JHNavigation)

#pragma mark - 导航条隐藏与显示

/// 导航条显示状态
@property (nonatomic, assign) JHNavigationBarStatus jh_navigationBarStatus;

#pragma mark - 页面支持方向
/*
兼容系统方法，若系统方法与jh_方法都存在，以jh_方法为准
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
*/

/// 页面旋转状态，是否支持自动旋转
@property (nonatomic, assign) JHAutorotateStatus jh_shouldAutorotate;
/// 页面默认方向
@property (nonatomic, assign) JHInterfaceOrientation jh_preferredInterfaceOrientationForPresentation;
/// 页面支持的方向
@property (nonatomic, assign) JHInterfaceOrientationMask jh_supportedInterfaceOrientations;

#pragma mark - 转场风格

/// Push风格
@property (nonatomic, assign) JHNavigationTransitionStyle jh_navigationPushStyle;
/// Pop风格
@property (nonatomic, assign) JHNavigationTransitionStyle jh_navigationPopStyle;

#pragma mark - 页面显示方式

/// 页面显示方式
@property (nonatomic, assign) JHScreenStyle jh_screenStyle;
/// 当页面显示方式为custom时调用
@property (nonatomic, assign) CGRect jh_frameFromFullScreen;
/// 空白区域的背景颜色
@property (nonatomic, strong) UIColor *jh_containerBackgroundColor;

#pragma mark - 是否需要跳过pop

/// 触发跳过pop状态。该页面是否需要跳过pop，返回YES则pop时不在该页面停留。
@property (nonatomic, assign) JHNeedTriggerSkipAtPopStatus jh_needTriggerSkipAtPopStatus;
/// 跳过pop状态。是否触发跳过pop操作，返回YES，会跳转到第一个jh_needSkipPop返回NO的页面；返回NO，不做任何处理。
@property (nonatomic, assign) JHNeedSkipPopStatus jh_needSkipPopStatus;

@end

NS_ASSUME_NONNULL_END
