//
//  UIViewController+JHNavigation.m
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "UIViewController+JHNavigation.h"
#import "UIViewController+JHNavigation_Private.h"
#import "UINavigationController+JHNavigation.h"
#import "UINavigationController+JHNavigation_Private.h"
#import "JHNavigationTransitionAnimator.h"
#import "JHNavigation.h"

#import <objc/runtime.h>

@interface UIViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationController *lastNavigationController;

@property (nonatomic, assign) BOOL jh_viewAppeared;

@end

@implementation UIViewController (JHNavigation)

#pragma mark - hook

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        method_exchangeImplementations(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)),
        class_getInstanceMethod([UIViewController class], @selector(jh_viewDidLoad)));
        
        method_exchangeImplementations(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)),
        class_getInstanceMethod([UIViewController class], @selector(jh_viewWillAppear:)));
        
        method_exchangeImplementations(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)),
        class_getInstanceMethod([UIViewController class], @selector(jh_viewWillDisappear:)));
        
        method_exchangeImplementations(class_getInstanceMethod([UIViewController class], @selector(dismissViewControllerAnimated:completion:)),
        class_getInstanceMethod([UIViewController class], @selector(jh_dismissViewControllerAnimated:completion:)));
        
        method_exchangeImplementations(class_getInstanceMethod([UIViewController class], @selector(presentViewController:animated:completion:)),
        class_getInstanceMethod([UIViewController class], @selector(jh_presentViewController:animated:completion:)));
        
    });
}

- (void)jh_viewDidLoad {
    [self jh_viewDidLoad];
    
    if (self.navigationController) {
        
        if (![self.navigationController.viewControllers containsObject:self]) {
            return;
        }
        
        if (!self.navigationController.delegate) {
            self.navigationController.delegate = self;
        }
        
        // 添加实现转场代理
        SEL navigationControllerTransitionSEL = @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:);
        
        if (![self.navigationController.delegate respondsToSelector:navigationControllerTransitionSEL]) {
            
            IMP navigationControllerTransitionIMP = [self methodForSelector:navigationControllerTransitionSEL];
            
            class_addMethod([self.navigationController.delegate class], navigationControllerTransitionSEL, navigationControllerTransitionIMP, "@@:@q@@");
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    // 若当前屏幕与目标默认方向不一致，则不处理转场
    JHInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (toVC.jh_navigationConfig.interfaceOrientation != JHInterfaceOrientationUnknown
        && orientation != toVC.jh_navigationConfig.interfaceOrientation) {
        return nil;
    }
    
    if (operation == UINavigationControllerOperationPush) {
        if (toVC.jh_navigationConfig.pushStyle != JHNavigationTransitionStyleUnknown) {
            return [JHNavigationPushAnimator new];
        }
    }
    if (operation == UINavigationControllerOperationPop) {
        if (fromVC.jh_navigationConfig.popStyle != JHNavigationTransitionStyleUnknown) {
            return [JHNavigationPopAnimator new];
        }
    }
    return nil;
}

- (void)jh_viewWillAppear:(BOOL)animated {
    [self jh_viewWillAppear:animated];
    [self setupNavigationConfig:animated];
}

- (void)jh_viewWillDisappear:(BOOL)animated {
    [self jh_viewWillDisappear:animated];
    self.jh_viewAppeared = YES;
}

- (void)setupNavigationConfig:(BOOL)animated {
    
    if (self.navigationController) {
        
        [JHNavigationContext sharedInstance].currentNavigationController = self.navigationController;
        
        if (![self.navigationController.viewControllers containsObject:self]) {
            return;
        }

        // 仅对第一次显示的VC读取本地配置，将配置记录到jh_navigationConfig中
        if (!self.jh_viewAppeared) {
            [self jh_loadNavigationConfig];
            [self jh_loadNavigationSkipConfig];
        }

        JHNavigationConfig *config = self.jh_navigationConfig;

        UINavigationController *navigationController = self.navigationController;

        // 对三个必要但未声明的属性，设置默认值
        if (config.navigationBarStatus == JHNavigationBarStatusUnknown) {
            config.navigationBarStatus = navigationController.navigationBarHidden ? JHNavigationBarStatusHidden : JHNavigationBarStatusDefault;
        }
        
        if (config.interfaceOrientation == JHInterfaceOrientationUnknown) {
            // 检查是否有实现的系统方法
            if (self.preferredInterfaceOrientationForPresentation != UIInterfaceOrientationUnknown) {
                config.interfaceOrientation = self.preferredInterfaceOrientationForPresentation;
            } else {
                config.interfaceOrientation = (JHInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation;
            }
        }
        
        if (config.autorotateStatus == JHAutorotateStatusUnknown) {
            config.autorotateStatus = navigationController.shouldAutorotate ? JHAutorotateStatusEnable : JHAutorotateStatusDisable;
        }
        
        // 控制导航条隐藏
        [navigationController setNavigationBarHidden:config.navigationBarStatus == JHNavigationBarStatusHidden animated:animated];

        // 控制页面旋转
        // 1. 打开页面旋转开关
        navigationController.jh_isShouldRotate = YES;
        
        // 2. 设置页面支持方向
        navigationController.jh_interfaceOrientationMask = config.interfaceOrientationMask;
        
        // 3. 设置页面默认方向
        navigationController.jh_interfaceOrientation = config.interfaceOrientation;
        
        if (config.interfaceOrientation != (JHInterfaceOrientation)[UIApplication sharedApplication].statusBarOrientation) {
            // 4. 旋转页面方向
            [self setInterfaceOrientation:config.interfaceOrientation];
        }
        
        // 5. 重设页面旋转开关
        navigationController.jh_isShouldRotate = config.autorotateStatus == JHAutorotateStatusEnable;
        
        // 解决侧滑无效的问题
        navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


// 记录上一个导航控制器
- (void)jh_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // 记录viewControllerToPresent的上一个导航控制器为当前导航控制器
    viewControllerToPresent.lastNavigationController = [UINavigationController currentNavigationController];
    
    [self jh_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

// 重设当前导航控制器为上一个导航控制器
- (void)jh_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([self isKindOfClass:[UINavigationController class]] || self.navigationController) {
        // 当前导航控制器
        UINavigationController *currentNavigationController = [UINavigationController currentNavigationController];
        // 上一个导航控制器
        UINavigationController *lastNavigationController = currentNavigationController.viewControllers.firstObject.lastNavigationController;
        // 设置当前导航控制器为上一个导航控制器
        if (lastNavigationController) {
            [JHNavigationContext sharedInstance].currentNavigationController = lastNavigationController;
        }
    }
    
    [self jh_dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - 读取 VC 导航配置

/// 读取导航配置中，页面旋转和导航条显示相关配置
- (void)jh_loadNavigationConfig {
    
    JHNavigationConfig *config = self.jh_navigationConfig;
    // 导航条相关
    if (config.navigationBarStatus == JHNavigationBarStatusUnknown) {
        config.navigationBarStatus = self.jh_navigationBarStatus;
    }
}

/// 读取导航配置中，页面跳转相关配置
- (void)jh_loadNavigationSkipConfig {
    
    JHNavigationConfig *config = self.jh_navigationConfig;
    
    // 控制页面转场相关
    // 1. Push 方式
    if (config.pushStyle == JHNavigationTransitionStyleUnknown) {
        config.pushStyle = self.jh_navigationPushStyle;
    }
    
    // 2. Pop 方式
    if (config.popStyle == JHNavigationTransitionStyleUnknown) {
        config.popStyle = self.jh_navigationPopStyle;
    }
    
    // 显示方式相关
    if (config.screenStyle == JHScreenStyleUnknown) {
        config.screenStyle = self.jh_screenStyle;
    }
    
    // 是否需要跳过pop相关
    // 1. 是否触发跳过pop
    if (config.needTriggerSkipAtPopStatus == JHNeedTriggerSkipAtPopUnknown) {
        config.needTriggerSkipAtPopStatus = self.jh_needTriggerSkipAtPopStatus;
    }
    // 2. 是否跳过pop
    if (config.needSkipPopStatus == JHNeedSkipPopStatusUnknown) {
        config.needSkipPopStatus = self.jh_needSkipPopStatus;
    }
    
    // 页面旋转相关
    // 1. 页面是否旋转
    if (config.autorotateStatus == JHAutorotateStatusUnknown) {
        if (self.jh_shouldAutorotate != JHAutorotateStatusUnknown) {
            config.autorotateStatus = self.jh_shouldAutorotate;
        } else if ([self respondsToSelector:@selector(shouldAutorotate)]) {
            config.autorotateStatus = [self shouldAutorotate] ? JHAutorotateStatusEnable : JHAutorotateStatusDisable;
        }
    }
    // 2. 页面默认方式
    if (config.interfaceOrientation == JHInterfaceOrientationUnknown) {
        if (self.jh_preferredInterfaceOrientationForPresentation != JHInterfaceOrientationUnknown) {
            config.interfaceOrientation = self.jh_preferredInterfaceOrientationForPresentation;
        } else if ([self respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
            config.interfaceOrientation = (JHInterfaceOrientation)self.preferredInterfaceOrientationForPresentation;
        }
    }
    // 3. 页面支持的方向
    if (config.interfaceOrientationMask == 0) {
        if (self.jh_supportedInterfaceOrientations != 0) {
            config.interfaceOrientationMask = self.jh_supportedInterfaceOrientations;
        } else if ([self respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            config.interfaceOrientationMask = (JHInterfaceOrientationMask)self.supportedInterfaceOrientations;
        }
    }
}

#pragma mark - 设置页面显示方向

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSMethodSignature *signature = [UIDevice instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = selector;
        invocation.target = [UIDevice currentDevice];
        NSInteger val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - 获取当前VC

+ (UIViewController *)findCurrentViewController:(UIViewController *)vc {

    if (vc.presentedViewController && ![vc.presentedViewController isKindOfClass:[UIAlertController class]]) {

        // Return presented view controller
        return [UIViewController findCurrentViewController:vc.presentedViewController];

    } else if ([vc isKindOfClass:[UISplitViewController class]]) {

        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findCurrentViewController:svc.viewControllers.lastObject];
        else
            return vc;

    } else if ([vc isKindOfClass:[UINavigationController class]]) {

        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findCurrentViewController:svc.topViewController];
        else
            return vc;

    } else if ([vc isKindOfClass:[UITabBarController class]]) {

        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findCurrentViewController:svc.selectedViewController];
        else
            return vc;

    } else {

        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (UIViewController *)currentVC {
    // Find best view controller
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    return [UIViewController findCurrentViewController:viewController];

}

#pragma mark - associated object

- (void)setJh_viewAppeared:(BOOL)jh_viewAppeared {
    objc_setAssociatedObject(self, @selector(jh_viewAppeared), @(jh_viewAppeared), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)jh_viewAppeared {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJh_navigationConfig:(JHNavigationConfig *)jh_navigationConfig {
    objc_setAssociatedObject(self, @selector(jh_navigationConfig), jh_navigationConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JHNavigationConfig *)jh_navigationConfig {
    
    JHNavigationConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        config = [[JHNavigationConfig alloc] init];
        [self setJh_navigationConfig:config];
    }
    return config;
}

- (void)setLastNavigationController:(UINavigationController *)lastNavigationController {
    objc_setAssociatedObject(self, @selector(lastNavigationController), lastNavigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationController *)lastNavigationController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJh_navigationBarStatus:(JHNavigationBarStatus)jh_navigationBarStatus {
    objc_setAssociatedObject(self, @selector(jh_navigationBarStatus), @(jh_navigationBarStatus), OBJC_ASSOCIATION_ASSIGN);
}

- (JHNavigationBarStatus)jh_navigationBarStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_shouldAutorotate:(JHAutorotateStatus)jh_shouldAutorotate {
    objc_setAssociatedObject(self, @selector(jh_shouldAutorotate), @(jh_shouldAutorotate), OBJC_ASSOCIATION_ASSIGN);
}

- (JHAutorotateStatus)jh_shouldAutorotate {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_preferredInterfaceOrientationForPresentation:(JHInterfaceOrientation)jh_preferredInterfaceOrientationForPresentation {
    objc_setAssociatedObject(self, @selector(jh_preferredInterfaceOrientationForPresentation), @(jh_preferredInterfaceOrientationForPresentation), OBJC_ASSOCIATION_ASSIGN);
}

- (JHInterfaceOrientation)jh_preferredInterfaceOrientationForPresentation {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_supportedInterfaceOrientations:(JHInterfaceOrientationMask)jh_supportedInterfaceOrientations {
    objc_setAssociatedObject(self, @selector(jh_supportedInterfaceOrientations), @(jh_supportedInterfaceOrientations), OBJC_ASSOCIATION_ASSIGN);
}

- (JHInterfaceOrientationMask)jh_supportedInterfaceOrientations {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_navigationPushStyle:(JHNavigationTransitionStyle)jh_navigationPushStyle {
    objc_setAssociatedObject(self, @selector(jh_navigationPushStyle), @(jh_navigationPushStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (JHNavigationTransitionStyle)jh_navigationPushStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_navigationPopStyle:(JHNavigationTransitionStyle)jh_navigationPopStyle {
    objc_setAssociatedObject(self, @selector(jh_navigationPopStyle), @(jh_navigationPopStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (JHNavigationTransitionStyle)jh_navigationPopStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_screenStyle:(JHScreenStyle)jh_screenStyle {
    objc_setAssociatedObject(self, @selector(jh_screenStyle), @(jh_screenStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (JHScreenStyle)jh_screenStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_frameFromFullScreen:(CGRect)jh_frameFromFullScreen {
    objc_setAssociatedObject(self, @selector(jh_frameFromFullScreen), @(jh_frameFromFullScreen), OBJC_ASSOCIATION_ASSIGN);
}

- (CGRect)jh_frameFromFullScreen {
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

- (void)setJh_containerBackgroundColor:(UIColor *)jh_containerBackgroundColor {
    objc_setAssociatedObject(self, @selector(jh_containerBackgroundColor), jh_containerBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)jh_containerBackgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJh_needTriggerSkipAtPopStatus:(JHNeedTriggerSkipAtPopStatus)jh_needTriggerSkipAtPopStatus {
    objc_setAssociatedObject(self, @selector(jh_needTriggerSkipAtPopStatus), @(jh_needTriggerSkipAtPopStatus), OBJC_ASSOCIATION_ASSIGN);
}

- (JHNeedTriggerSkipAtPopStatus)jh_needTriggerSkipAtPopStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setJh_needSkipPopStatus:(JHNeedSkipPopStatus)jh_needSkipPopStatus {
    objc_setAssociatedObject(self, @selector(jh_needSkipPopStatus), @(jh_needSkipPopStatus), OBJC_ASSOCIATION_ASSIGN);
}

- (JHNeedSkipPopStatus)jh_needSkipPopStatus {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end

@implementation JHNavigationConfig

@end
