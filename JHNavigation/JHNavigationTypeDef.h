//
//  JHNavigationTypeDef.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#ifndef JHNavigationTypeDef_h
#define JHNavigationTypeDef_h

/// 导航条显示状态
typedef NS_ENUM(NSUInteger, JHNavigationBarStatus) {
    JHNavigationBarStatusUnknown = 0, // 未知
    JHNavigationBarStatusDefault, // 显示导航条，默认
    JHNavigationBarStatusHidden, // 隐藏导航条
};

/// 页面旋转状态
typedef NS_ENUM(NSUInteger, JHAutorotateStatus) {
    JHAutorotateStatusUnknown, // 未知
    JHAutorotateStatusEnable, // 允许旋转，默认
    JHAutorotateStatusDisable, // 不允许旋转
};

/// 页面弹出方式
typedef NS_ENUM(NSUInteger, JHNavigationTransitionStyle) {
    JHNavigationTransitionStyleUnknown = 0, // 未知
    JHNavigationTransitionStyleMiddle, // 中间弹出
    JHNavigationTransitionStyleTop, // 顶部弹出
    JHNavigationTransitionStyleLeft, // 左侧弹出
    JHNavigationTransitionStyleBottom, // 底部弹出
    JHNavigationTransitionStyleRight, // 右侧弹出，默认
};

/// 页面显示方式
typedef NS_ENUM(NSUInteger, JHScreenStyle) {
    JHScreenStyleUnknown = 0, // 未知
    JHScreenStyleFull, // 默认
    JHScreenStyleCustom, // 将VC添加到一个透明VC上，底部弹出
};

/// 触发跳过pop状态
typedef NS_ENUM(NSUInteger, JHNeedTriggerSkipAtPopStatus) {
    JHNeedTriggerSkipAtPopUnknown = 0, // 未知
    JHNeedTriggerSkipAtPopEnable, // 触发跳过pop操作
    JHNeedTriggerSkipAtPopDisable // 不触发，默认
};

/// 跳过pop状态
typedef NS_ENUM(NSUInteger, JHNeedSkipPopStatus) {
    JHNeedSkipPopStatusUnknown = 0, // 未知
    JHNeedSkipPopStatusEnable, // 跳过pop
    JHNeedSkipPopStatusDisable // 不跳过，默认
};

/// 页面默认方向
typedef NS_ENUM(NSUInteger, JHInterfaceOrientation) {
    JHInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
    JHInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
    JHInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
    JHInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
    JHInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
};

/// 页面支持的方向
typedef NS_OPTIONS(NSUInteger, JHInterfaceOrientationMask) {
    JHInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
    JHInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
    JHInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
    JHInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
    JHInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
    JHInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
    JHInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
};

#endif /* JHNavigationTypeDef_h */
