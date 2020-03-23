//
//  JHNavigationTransitionAnimator.m
//  JHNavigation
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "JHNavigationTransitionAnimator.h"

#import "UIViewController+JHNavigation_Private.h"

@implementation JHNavigationPushAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    switch (toVC.jh_navigationConfig.pushStyle) {
        case JHNavigationTransitionStyleUnknown:
        {
            break;
        }
        case JHNavigationTransitionStyleMiddle:
        {
            toView.transform = CGAffineTransformMakeScale(0, 0);
            break;
        }
        case JHNavigationTransitionStyleTop:
        {
            initialFrame = CGRectMake(toView.frame.origin.x, -CGRectGetMaxY(toView.frame), toView.bounds.size.width, toView.bounds.size.height);
            finalFrame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            break;
        }
        case JHNavigationTransitionStyleLeft:
        {
            initialFrame = CGRectMake(-CGRectGetMaxX(toView.frame), toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            finalFrame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            break;
        }
        case JHNavigationTransitionStyleBottom:
        {
            initialFrame = CGRectMake(toView.frame.origin.x, CGRectGetMaxY(toView.frame), toView.frame.size.width, toView.frame.size.height);
            finalFrame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            break;
        }
        case JHNavigationTransitionStyleRight:
        {
            initialFrame = CGRectMake(CGRectGetMaxX(toView.frame), toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            finalFrame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y, toView.bounds.size.width, toView.bounds.size.height);
            break;
        }
        default:
            break;
    }
    if (toVC.jh_navigationConfig.pushStyle != JHNavigationTransitionStyleMiddle) {
        toView.frame = initialFrame;
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (toVC.jh_navigationConfig.pushStyle == JHNavigationTransitionStyleMiddle) {
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } else {
            toView.frame = finalFrame;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end

@implementation JHNavigationPopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView bringSubviewToFront:fromView];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = [transitionContext finalFrameForViewController:fromVC];
    
    switch (fromVC.jh_navigationConfig.popStyle) {
        case JHNavigationTransitionStyleUnknown:
        {
            break;
        }
        case JHNavigationTransitionStyleMiddle:
        {
            break;
        }
        case JHNavigationTransitionStyleTop:
        {
            initialFrame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            finalFrame = CGRectMake(fromView.frame.origin.x, -CGRectGetMaxY(fromView.frame), fromView.frame.size.width, fromView.frame.size.height);
            break;
        }
        case JHNavigationTransitionStyleLeft:
        {
            initialFrame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            finalFrame = CGRectMake(-CGRectGetMaxX(fromView.frame), fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            break;
        }
        case JHNavigationTransitionStyleBottom:
        {
            initialFrame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            finalFrame = CGRectMake(fromView.frame.origin.x, CGRectGetMaxY(fromView.frame), fromView.frame.size.width, fromView.frame.size.height);
            break;
        }
        case JHNavigationTransitionStyleRight:
        {
            initialFrame = CGRectMake(fromView.frame.origin.x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            finalFrame = CGRectMake(CGRectGetMaxX(fromView.frame), fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            break;
        }
        default:
            break;
    }
    if (fromVC.jh_navigationConfig.popStyle != JHNavigationTransitionStyleMiddle) {
        fromView.frame = initialFrame;
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (fromVC.jh_navigationConfig.popStyle == JHNavigationTransitionStyleMiddle) {
            fromView.transform = CGAffineTransformMakeScale(0, 0);
        } else {
            fromView.frame = finalFrame;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
