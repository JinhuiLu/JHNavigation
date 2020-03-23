# JHNavigation
方便路由使用的iOS导航控制方式

为什么要开发这个库？
由于多人合作开发，每个人只关注自身页面的样式实现。但由于页面越来越多，且大部分页面都支持了路由，导致页面间的跳转关系将会非常复杂且不可预知，所以主要是为了解决这个问题。

> **核心思想：**
> **使用者只需要关心自身页面的样式即可**

本库采用为UIViewController和UINavigationController添加category的方式实现。直接导入即可使用。

`UIViewController+JHNavigation.h` 和 `UINavigationController+JHNavigation.h`为主要使用类

另：JHNavigation会在页面跳转时记录当前页面状态（导航条的显示，屏幕旋转方向），在回退（pop）时仍保持原本状态。

## 导航条的显示相关
例一：
>A页面带导航条，
B页面不带导航条，
C页面带导航条。
当三个页面相互跳转时，需要在viewWillAppear和viewWillDisAppear里设置设置导航条的显示和隐藏.

使用JHNavigation后，只需要在viewDidLoad时设置当前页面的导航条显示状态即可，页面间的跳转无需管理。
```
A页面
- (void)viewDidLoad {
    self.jh_navigationBarStatus = JHNavigationBarStatusDefault;
}

B页面
- (void)viewDidLoad {
    self.jh_navigationBarStatus = JHNavigationBarStatusHidden;
}

C页面
- (void)viewDidLoad {
    self.jh_navigationBarStatus = JHNavigationBarStatusDefault;
}
```

## 屏幕旋转相关
例二：
>A页面为竖屏不可旋转
>B页面为横屏可以旋转

同样的思路，只需要给需要展示的页面设置需要展示的状态即可。

```
A页面
- (void)viewDidLoad {
    self.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationPortrait;
    self.jh_shouldAutorotate = JHAutorotateStatusDisable;
}

B页面
- (void)viewDidLoad {
    self.jh_shouldAutorotate = JHAutorotateStatusEnable;
    self.jh_preferredInterfaceOrientationForPresentation = JHInterfaceOrientationLandscapeRight;
}
```

## 转场方式
## 更多操作
## 详见Demo
