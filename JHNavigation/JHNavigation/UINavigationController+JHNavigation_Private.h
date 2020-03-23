//
//  UINavigationController+JHNavigation_Private.h
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JHNavigation.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (JHNavigation_Private)

/*
 三个传递给导航控制器的页面旋转的属性
 */
@property (nonatomic, assign) BOOL jh_isShouldRotate;

@property (nonatomic, assign) JHInterfaceOrientationMask jh_interfaceOrientationMask;

@property (nonatomic, assign) JHInterfaceOrientation jh_interfaceOrientation;

@end


@interface JHNavigationContext : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) UINavigationController *currentNavigationController;

@end

NS_ASSUME_NONNULL_END
