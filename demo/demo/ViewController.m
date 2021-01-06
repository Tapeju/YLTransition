//
//  ViewController.m
//  demo
//
//  Created by TaPeJu on 2020/12/24.
//

#import "ViewController.h"
#import "YLTransition.h"

#import "LeftViewController.h"
#import "RightViewController.h"
#import "TopViewController.h"
#import "BottomViewController.h"
#import "BottomScrollViewController.h"
#import "CenterViewController.h"
#import "CustomAnimator.h"
#import "CustomViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    /// 四种手势驱动 Present 用法
    [self addRightGestureRecognizer];
    [self addLeftGestureRecognizer];
    [self addTopGestureRecognizer];
    [self addBottomGestureRecognizer];
    
    /// 普通用法
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 35)];
    [btn setTitle:@"show ViewController" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    /// 自定义动画
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 35)];
    [btn2 setTitle:@"show CustomAnimator" forState:UIControlStateNormal];
    [btn2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showCustomAnimatorVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    /// 手势冲突
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 35)];
    [btn3 setTitle:@"show ContentScrollView" forState:UIControlStateNormal];
    [btn3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(showContentScrollView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}


- (void)showVc {
    CenterViewController *presentedVc = [[CenterViewController alloc] init];
    YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:presentedVc presentingViewController:self];
    manager.animationType = YLAnimationTypeCrossDissolve;
    manager.viewAlignment = YLAlignment_Center;
    manager.dragable = YES;
    manager.radius = 13;
    [self presentViewController:presentedVc animated:YES completion:nil];
}

- (void)showCustomAnimatorVc {
    CustomViewController *presentedVc = [[CustomViewController alloc] init];
    YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:presentedVc presentingViewController:self];
    CustomAnimator *animator =  [[CustomAnimator alloc] init];
    manager.customAnimator = animator;
    manager.dragable = YES;
    manager.radius = 13;
    manager.viewAlignment = YLAlignment_Top;
    manager.viewEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [self presentViewController:presentedVc animated:YES completion:nil];
}

- (void)showContentScrollView {
    BottomScrollViewController *bottomScrollView = [[BottomScrollViewController alloc] init];
    YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:bottomScrollView presentingViewController:self];
    manager.animationType = YLAnimationTypeTranslation;
    manager.viewAlignment = YLAlignment_Bottom;
    manager.dragable = YES;
    [manager setContentScrollView:bottomScrollView.tableView];
    manager.radius = 13;
    [self presentViewController:bottomScrollView animated:YES completion:nil];
    
}

- (void)addRightGestureRecognizer {
    __weak __typeof(self)weakSelf = self;
    YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[YLLeftPanGesTureRecognizer alloc] init];
    __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;
    interactiveTransitionRecognizer.presentBlock = ^{
        PresentedViewController *vc = [[RightViewController alloc] init];
        YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        manager.presentGesture = weakInteractive;
        manager.animationType = YLAnimationTypeTranslation;
        manager.viewAlignment = YLAlignment_Right;
        manager.dragable = YES;
        manager.radius = 13;
        manager.zoomScale = 0.90;
        manager.rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (void)addLeftGestureRecognizer {
    __weak __typeof(self)weakSelf = self;
    YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[YLRightPanGesTureRecognizer alloc] init];
    __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;
    interactiveTransitionRecognizer.presentBlock = ^{
        PresentedViewController *vc = [[LeftViewController alloc] init];
        YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        manager.presentGesture = weakInteractive;
        manager.animationType = YLAnimationTypeTranslation;
        manager.viewAlignment = YLAlignment_Left;
        manager.dragable = YES;
        manager.radius = 13;
        manager.zoomScale = 0.90;
        manager.rectCorner = UIRectCornerTopRight| UIRectCornerBottomRight;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (void)addTopGestureRecognizer {
    __weak __typeof(self)weakSelf = self;
    YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[YLBottomPanGesTureRecognizer alloc] init];
    __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;
    interactiveTransitionRecognizer.presentBlock = ^{
        PresentedViewController *vc = [[TopViewController alloc] init];
        YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        manager.presentGesture = weakInteractive;
        manager.animationType = YLAnimationTypeTranslation;
        manager.viewAlignment = YLAlignment_Top;
        manager.dragable = YES;
        manager.radius = 13;
        manager.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

- (void)addBottomGestureRecognizer {
    __weak __typeof(self)weakSelf = self;
    YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[YLTopPanGesTureRecognizer alloc] init];
    __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;
    interactiveTransitionRecognizer.presentBlock = ^{
        PresentedViewController *vc = [[BottomViewController alloc] init];
        YLModalTransitionManager *manager = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        manager.presentGesture = weakInteractive;
        manager.animationType = YLAnimationTypeTranslation;
        manager.viewAlignment = YLAlignment_Bottom;
        manager.dragable = YES;
        manager.radius = 13;
        manager.rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

@end
