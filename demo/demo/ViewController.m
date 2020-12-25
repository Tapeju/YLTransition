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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self addRightGestureRecognizer];
    [self addLeftGestureRecognizer];
    [self addTopGestureRecognizer];
    [self addBottomGestureRecognizer];
}


- (void)showVc {
    PresentedViewController *presentedVc = [[PresentedViewController alloc] init];
    YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:presentedVc presentingViewController:self];
    animator.animationType = YLAnimationTypeTranslationRight;
    animator.dragable = YES;
    [self presentViewController:presentedVc animated:YES completion:nil];
}

- (void)addRightGestureRecognizer {
    __weak __typeof(self)weakSelf = self;
    YLDirectionAbstractPanGesTureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[YLLeftPanGesTureRecognizer alloc] init];
    __weak __typeof(interactiveTransitionRecognizer)weakInteractive = interactiveTransitionRecognizer;
    interactiveTransitionRecognizer.presentBlock = ^{
        PresentedViewController *vc = [[RightViewController alloc] init];
        YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        animator.presentGesture = weakInteractive;
        animator.animationType = YLAnimationTypeTranslationRight;
        animator.dragable = YES;
        animator.radius = 13;
        animator.zoomScale = 0.90;
        animator.rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
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
        YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        animator.presentGesture = weakInteractive;
        animator.animationType = YLAnimationTypeTranslationLeft;
        animator.dragable = YES;
        animator.radius = 13;
        animator.zoomScale = 0.90;
        animator.rectCorner = UIRectCornerTopRight| UIRectCornerBottomRight;
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
        YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        animator.presentGesture = weakInteractive;
        animator.animationType = YLAnimationTypeTranslationTop;
        animator.dragable = YES;
        animator.radius = 13;
        animator.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
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
        YLModalTransitionManager *animator = [[YLModalTransitionManager alloc] initWithPresentedViewController:vc presentingViewController:weakSelf];
        animator.presentGesture = weakInteractive;
        animator.animationType = YLAnimationTypeTranslationBottom;
        animator.dragable = YES;
        animator.radius = 13;
        animator.rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

@end
