//
//  SimpleRouter.m
//  JHNavigationExample
//
//  Created by lujinhui on 2020/3/23.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "SimpleRouter.h"

#import "JHNavigation.h"
#import <objc/runtime.h>

@implementation SimpleRouter

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 模拟路由携带参数
- (void)handleUrl:(NSString *)urlStr {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlStr];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value) {
            [params setObject:obj.value forKey:obj.name];
        }
    }];
    
    if (params[@"target"]) {
        Class vcClass = NSClassFromString(params[@"target"]);
        if (vcClass && [vcClass isSubclassOfClass:[UIViewController class]]) {
            
            UIViewController *vc = [[vcClass alloc] init];
            
            [params removeObjectForKey:@"target"];
            
            [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [vc setValue:@([obj integerValue]) forKey:key];
            }];
            
            [[UINavigationController currentNavigationController] pushViewController:vc animated:YES];
        }
    }
}

@end
