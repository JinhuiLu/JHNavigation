//
//  UINavigationController+JHNavigation.m
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "UINavigationController+JHNavigation.h"
#import "UIViewController+JHNavigation_Private.h"
#import "JHNavigationTransitionAnimator.h"
#import "JHNavCustomViewController.h"
#import "UINavigationController+JHNavigation_Private.h"

#import <objc/message.h>

@implementation UINavigationController (JHNavigation)

#pragma mark - hook

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(pushViewController:animated:)),
        class_getInstanceMethod([self class], @selector(jh_pushViewController:animated:)));
        
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)),
        class_getInstanceMethod([self class], @selector(jh_popViewControllerAnimated:)));
    });
}

#pragma mark - Private

- (void)jh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 记录当前页面导航配置
    [self saveTopViewControllerNavConfig];
    
    // 读取JHNavigationProtocol 中页面跳转相关配置
    [viewController jh_loadNavigationSkipConfig];
    
    // 对screenStyle处理
    if ([self checkViewControllerScreenStyle:viewController animated:animated]) {
        return;
    }
    
    [self jh_pushViewController:viewController animated:animated];
}

- (UIViewController *)jh_popViewControllerAnimated:(BOOL)animated {
    
    // 记录当前页面导航配置
    [self saveTopViewControllerNavConfig];
    
    // 如果url中存在useSkipPop=1，则跳转viewcontrollers中首个needSkipPop为NO
    if (self.topViewController.jh_navigationConfig.needTriggerSkipAtPopStatus == JHNeedTriggerSkipAtPopEnable) {

        NSArray *viewControllers = self.viewControllers;
        NSUInteger count = viewControllers.count;

        __block UIViewController *findVC = nil;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < count - 1) {
                if (obj.jh_navigationConfig.needSkipPopStatus != JHNeedSkipPopStatusEnable) {
                    findVC = obj;
                    [self popToViewController:obj animated:animated];
                    *stop = YES;
                }
            }
        }];

        if (findVC) {
            return findVC;
        }
    }
    
    // 处理弹出半屏时，使用pop方法退出的情况
    if (self.viewControllers.count == 1) {
        // 如果是半屏的根视图控制器
        if ([self.viewControllers[0] isKindOfClass:[JHNavCustomViewController class]]) {
            
            [((JHNavCustomViewController *)self.viewControllers[0]) removeCustomChildViewControllerAnimated:animated completion:^{
                [self.viewControllers[0] dismissViewControllerAnimated:NO completion:nil];
            }];
            
            return nil;
        }
    }
    
    return [self jh_popViewControllerAnimated:animated];
}

- (void)saveTopViewControllerNavConfig {
    JHNavigationConfig *config = self.topViewController.jh_navigationConfig;
    config.navigationBarStatus = self.navigationBarHidden ? JHNavigationBarStatusHidden : JHNavigationBarStatusDefault;
    config.interfaceOrientation = (JHInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - 处理半屏

/// 检查目标控制器的屏幕风格。如果是自定义风格，则直接处理，返回YES
/// @param viewController 目标控制器
/// @param animated 是否需要动画
- (BOOL)checkViewControllerScreenStyle:(UIViewController *)viewController animated:(BOOL)animated {
    // 读取vc中实现的JHNavigationProtocol的导航配置
    if (viewController.jh_navigationConfig.screenStyle == JHScreenStyleUnknown && [viewController respondsToSelector:@selector(jh_screenStyle)]) {
        viewController.jh_navigationConfig.screenStyle = [viewController jh_screenStyle];
    }
    
    // 对自定义透明背景页面的处理
    if (viewController.jh_navigationConfig.screenStyle == JHScreenStyleCustom) {
        
        JHNavCustomViewController *customViewController = [[JHNavCustomViewController alloc] init];
        customViewController.lastNavigationController = self;
        
        // model弹出的透明VC
        UINavigationController *halfNavigationController = [self jh_makeNewNavigationController];
        halfNavigationController.viewControllers = @[customViewController];
        halfNavigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [viewController jh_loadNavigationConfig];
        [viewController jh_loadNavigationSkipConfig];
        customViewController.jh_navigationConfig = viewController.jh_navigationConfig;
        
        [self.topViewController presentViewController:halfNavigationController animated:NO completion:^{
            customViewController.containerView.hidden = NO;
            [customViewController addCustomChildViewController:viewController animated:animated completion:^{
                
                // 兼容有些同学使用了UINavigationController+SafeTransition中的安全push机制
                if ([self respondsToSelector:NSSelectorFromString(@"setViewTransitionInProgress:")] && [self respondsToSelector:NSSelectorFromString(@"viewTransitionInProgress")]) {
                    [self setValue:@(NO) forKey:@"viewTransitionInProgress"];
                }
            }];
        }];

        return YES;
    }
    return NO;
}

// 创建一个等同自身样式的导航控制器
- (UINavigationController *)jh_makeNewNavigationController {
    
    UINavigationController *navigationController = [[[self class] alloc] initWithNavigationBarClass:self.navigationBar.class toolbarClass:self.toolbar.class];
    
    navigationController.navigationBar.barStyle = self.navigationBar.barStyle;
    navigationController.navigationBar.tintColor = self.navigationBar.tintColor;
    navigationController.navigationBar.barTintColor = self.navigationBar.barTintColor;
    navigationController.navigationBar.shadowImage = self.navigationBar.shadowImage;
    navigationController.navigationBar.titleTextAttributes = self.navigationBar.titleTextAttributes;
    navigationController.navigationBar.backIndicatorImage = self.navigationBar.backIndicatorImage;
    navigationController.navigationBar.backIndicatorTransitionMaskImage = self.navigationBar.backIndicatorTransitionMaskImage;
    if (@available(iOS 11.0, *)) {
        navigationController.navigationBar.prefersLargeTitles = self.navigationBar.prefersLargeTitles;
        navigationController.navigationBar.largeTitleTextAttributes = self.navigationBar.largeTitleTextAttributes;
    }
    if (@available(iOS 13.0, *)) {
        navigationController.navigationBar.compactAppearance = self.navigationBar.compactAppearance;
        navigationController.navigationBar.scrollEdgeAppearance = self.navigationBar.scrollEdgeAppearance;
        navigationController.navigationBar.standardAppearance = self.navigationBar.standardAppearance;
    }
    
    navigationController.navigationBarHidden = self.isNavigationBarHidden;
    navigationController.toolbarHidden = self.isToolbarHidden;
    navigationController.delegate = self.delegate;
    navigationController.hidesBarsWhenKeyboardAppears = self.hidesBarsWhenKeyboardAppears;
    navigationController.hidesBarsOnSwipe = self.hidesBarsOnSwipe;
    navigationController.hidesBarsWhenVerticallyCompact = self.hidesBarsWhenVerticallyCompact;
    navigationController.hidesBarsOnTap = self.hidesBarsOnTap;
    
    return navigationController;
}

#pragma mark - 页面旋转相关

- (BOOL)shouldAutorotate {
    return self.jh_isShouldRotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMask)self.jh_interfaceOrientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientation)self.jh_interfaceOrientation;
}

#pragma mark - associated object

- (void)setJh_isShouldRotate:(BOOL)jh_isShouldRotate {
    objc_setAssociatedObject(self, @selector(jh_isShouldRotate), @(jh_isShouldRotate), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)jh_isShouldRotate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJh_interfaceOrientation:(JHInterfaceOrientation)jh_interfaceOrientation {
    objc_setAssociatedObject(self, @selector(jh_interfaceOrientation), @(jh_interfaceOrientation), OBJC_ASSOCIATION_ASSIGN);
}

- (JHInterfaceOrientation)jh_interfaceOrientation {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_interfaceOrientationMask:(JHInterfaceOrientationMask)jh_interfaceOrientationMask {
    objc_setAssociatedObject(self, @selector(jh_interfaceOrientationMask), @(jh_interfaceOrientationMask), OBJC_ASSOCIATION_ASSIGN);
}

- (JHInterfaceOrientationMask)jh_interfaceOrientationMask {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

+ (UINavigationController *)currentNavigationController {
    return [JHNavigationContext sharedInstance].currentNavigationController;
}

@end

@implementation JHNavigationContext

+ (instancetype)sharedInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [JHNavigationContext sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [JHNavigationContext sharedInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [JHNavigationContext sharedInstance];
}

- (UINavigationController *)currentNavigationController {
    if (!_currentNavigationController) {
        // 获取当前vc的导航控制器
        if ([UIViewController jh_currentVC].navigationController) {
            _currentNavigationController = [UIViewController jh_currentVC].navigationController;
        }
    }
    return _currentNavigationController;
}

@end
