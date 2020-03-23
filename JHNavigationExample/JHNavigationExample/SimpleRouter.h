//
//  SimpleRouter.h
//  JHNavigationExample
//
//  Created by lujinhui on 2020/3/23.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleRouter : NSObject

+ (instancetype)sharedInstance;

// 模拟路由携带参数
- (void)handleUrl:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
