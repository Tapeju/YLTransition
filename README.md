# YLTransition

YLTransition是一个用于动画、非交互式和交互式ViewController Present和Dismiss的库

<img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.46.59.gif?raw=true" width="80" style="display: block;
  float: left"> <img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.47.27.gif?raw=true" width="80" style="display: block;
  float: left"> <img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.48.16.gif?raw=true" width="80" style="display: block;
  float: left"> <img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.49.40.gif?raw=true" width="80" style="display: block;
  float: left"> <img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.48.51.gif?raw=true" width="80" style="display: block;
  float: left"><img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.49.59.gif?raw=true" width="80" style="display: block;
  float: left"><img src="https://github.com/Tapeju/YLTransition/blob/main/github/2020-12-29%2016.50.33.gif?raw=true" width="80" style="display: block;
  float: left">







## 使用

```objective-c
#import <YLTransition/YLTransition.h>

PresentedViewController *presentedVc = [[PresentedViewController alloc] init];
YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:presentedVc presentingViewController:self];
animator.animationType = YLAnimationTypeTransformCenter;
[self presentViewController:presentedVc animated:YES completion:nil];
```

在PresentedViewController 中需加入以下代码, 用于自适应弹出控制器的宽高

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}
```

对于需要根据网络返回数据确定大小的, 只需要在拿到网络数据之后重新设置`self.preferredContentSize` 即可自适应大小

### interactive transition

#### Dismiss

只需要一行代码即可实现interactrive dismiss

```objective-c
animator.dragable = YES;
```

如果你present出来的controller上有scrollView, 并且想要支持拖动dismiss 也只需要一行代码,内部做好了所有事情
```objective-c
[animator setContentScrollView:presentedVc.scrollview];
```

#### Present

```objective-c

  __weak __typeof(self)weakSelf = self;
// YLDirectionAbstractPanGesTureRecognizer 该手势只接受向特定方向滑动的事件 
// YLLeftPanGesTureRecognizer 为 YLDirectionAbstractPanGesTureRecognizer 子类 只接受向左滑动的事件
  YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer = [[YLLeftPanGesTureRecognizer alloc] init];
  __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;

  interactiveTransitionRecognizer.presentBlock = ^{
     PresentedViewController *vc = [[RightViewController alloc] init];
     YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
     animator.presentGesture = weakInteractive;
     animator.viewAlignment = YLAlignment_Right;
     animator.animationType = YLAnimationTypeTranslation;
     animator.dragable = YES;
     [weakSelf presentViewController:vc animated:YES completion:nil];
  };

  [self.view addGestureRecognizer:interactiveTransitionRecognizer];
```

## 自定义

动画可以用各种设置来配置:

- `radius`  
- `rectCorner` 
- `damping`
- `duration`
- `animationType`
- `zoomScale`
- `presentGesture`
- `dragable`
- `viewAlignment`
- `viewEdgeInsets`
- `customAnimator`

### 自定义动画

YLTransition内部的动画效果如果无法满足你的个性化需求, 可用`customAnimator`属性实现自定义动画, `customAnimator` 继承自`YLAbstractAnimator` , 只需要实现`- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext` 方法即可实现自定义动画, 只要设置`viewAlignment` , YLTransition同样可以提供 `interactive transition` 手势驱动支持, 无需你额外写任何代码, 具体可见demo

```objective-c
		CustomViewController *presentedVc = [[CustomViewController alloc] init];
    YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] 	  initWithPresentedViewController:presentedVc presentingViewController:self];
    CustomAnimator *animator =  [[CustomAnimator alloc] init];
    manager.customAnimator = animator;
    manager.dragable = YES;
    manager.radius = 13;
    manager.viewAlignment = YLAlignment_Top;
    manager.viewEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [self presentViewController:presentedVc animated:YES completion:nil];
```

## 安装

- 使用 CocoaPods
  
    ```ruby
    pod "YLTransition"
    ```
    
- 将YLTransition 文件夹放入你的项目即可

## 作者

673795524@qq.com

## 许可

YLTransition is available under the MIT license. See the LICENSE file for more info.
