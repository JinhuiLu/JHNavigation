//
//  TableViewController.m
//  JHNavigationExample
//
//  Created by lujinhui on 2020/3/18.
//  Copyright © 2020 lujinhui. All rights reserved.
//

#import "TableViewController.h"

#import "JHNavigation.h"
#import "AViewController.h"
#import "SimpleRouter.h"

// 取消注释则开启路由方式测试
//#define USEURL

@interface TableViewController ()

@property (nonatomic, copy) NSArray *navbarArray;
@property (nonatomic, copy) NSArray *orientationArray;
@property (nonatomic, copy) NSArray *transitionArray;
@property (nonatomic, copy) NSArray *otherArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jh_navigationBarStatus = JHNavigationBarStatusDefault;
    self.jh_shouldAutorotate = JHAutorotateStatusDisable;
    self.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationPortrait;
    
    self.navbarArray = @[@"隐藏导航条"];
    
    self.orientationArray = @[@"横屏，且支持自动旋转",
                              @"横屏，且不支持自动旋转",
                              @"竖屏，且支持自动旋转",
                              @"竖屏，且不支持自动旋转"];
    
    self.transitionArray = @[@"底部弹出",
                             @"左侧弹出",
                             @"顶部弹出",
                             @"中间弹出"];
    
    self.otherArray = @[@"半屏弹出"];
}

#pragma mark - 导航条相关

- (void)nav0 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_navigationBarStatus=2"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_navigationBarStatus = JHNavigationBarStatusHidden;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

#pragma mark - 屏幕旋转相关

- (void)ori0 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_shouldAutorotate=1&jh_preferredInterfaceOrientationForPresentation=3"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusEnable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationLandscapeRight;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)ori1 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_shouldAutorotate=2&jh_preferredInterfaceOrientationForPresentation=3"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusDisable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationLandscapeRight;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)ori2 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_shouldAutorotate=1&jh_preferredInterfaceOrientationForPresentation=1"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusEnable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationPortrait;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)ori3 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_shouldAutorotate=2&jh_preferredInterfaceOrientationForPresentation=1"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_shouldAutorotate = JHAutorotateStatusDisable;
    aVc.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationPortrait;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

#pragma mark - 转场相关

- (void)tran0 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_navigationPushStyle=4&jh_navigationPopStyle=4"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_navigationPushStyle = JHNavigationTransitionStyleBottom;
    aVc.jh_navigationPopStyle = JHNavigationTransitionStyleBottom;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)tran1 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_navigationPushStyle=3&jh_navigationPopStyle=3"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_navigationPushStyle = JHNavigationTransitionStyleLeft;
    aVc.jh_navigationPopStyle = JHNavigationTransitionStyleLeft;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)tran2 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_navigationPushStyle=2&jh_navigationPopStyle=2"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_navigationPushStyle = JHNavigationTransitionStyleTop;
    aVc.jh_navigationPopStyle = JHNavigationTransitionStyleTop;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

- (void)tran3 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_navigationPushStyle=1&jh_navigationPopStyle=1"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_navigationPushStyle = JHNavigationTransitionStyleMiddle;
    aVc.jh_navigationPopStyle = JHNavigationTransitionStyleMiddle;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

#pragma mark - 其他新增

- (void)oth0 {
#ifdef USEURL
    [[SimpleRouter sharedInstance] handleUrl:[NSString stringWithFormat:@"hn://jumpToVC?target=AViewController&jh_screenStyle=2&jh_navigationBarStatus=2"]];
#else
    AViewController *aVc = [[AViewController alloc] init];
    aVc.jh_screenStyle = JHScreenStyleCustom;
    aVc.jh_frameFromFullScreen = CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2.f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2.f);
    aVc.jh_containerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    aVc.jh_navigationBarStatus = JHNavigationBarStatusHidden;
    [self.navigationController pushViewController:aVc animated:YES];
#endif
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"导航条是否隐藏";
        }
        case 1: {
            return @"屏幕方向切换";
        }
        case 2: {
            return @"转场方式切换";
        }
        case 3: {
            return @"其他新增样式";
        }
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return self.navbarArray.count;
        }
        case 1: {
            return self.orientationArray.count;
        }
        case 2: {
            return self.transitionArray.count;
        }
        case 3: {
            return self.otherArray.count;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.navbarArray[indexPath.row];
            break;
        }
        case 1: {
            cell.textLabel.text = self.orientationArray[indexPath.row];
            break;
        }
        case 2: {
            cell.textLabel.text = self.transitionArray[indexPath.row];
            break;
        }
        case 3: {
            cell.textLabel.text = self.otherArray[indexPath.row];
            break;
        }
        default:
            cell.textLabel.text = @"";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SEL selector = NULL;
    
    switch (indexPath.section) {
        case 0: {
            selector = NSSelectorFromString([NSString stringWithFormat:@"nav%zd", indexPath.row]);
            break;
        }
        case 1: {
            selector = NSSelectorFromString([NSString stringWithFormat:@"ori%zd", indexPath.row]);
            break;
        }
        case 2: {
            selector = NSSelectorFromString([NSString stringWithFormat:@"tran%zd", indexPath.row]);
            break;
        }
        case 3: {
            selector = NSSelectorFromString([NSString stringWithFormat:@"oth%zd", indexPath.row]);
            break;
        }
        default:
            break;
    }
    
    if (selector && [self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
}

@end
