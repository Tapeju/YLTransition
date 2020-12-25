//
//  YLModalTransitionManager.m
//
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLModalTransitionManager.h"
#import "YLAbstractAnimator.h"
#import "YLTranslationAnimator.h"
#import "YLTransformAnimator.h"
#import "YLCrossDissolveAnimator.h"
#import "YLPresentInteractiveTransition.h"
#import "YLDismissInteractiveTransition.h"
#import "YLDirectionAbstractPanGesTureRecognizer.h"
#import "YLLeftPanGesTureRecognizer.h"
#import "YLRightPanGesTureRecognizer.h"
#import "YLTopPanGesTureRecognizer.h"
#import "YLBottomPanGesTureRecognizer.h"
#import "UIView+YLEffect.h"

@interface YLModalTransitionManager () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) YLDirectionAbstractPanGesTureRecognizer *dismissGesture;
@property (nonatomic, assign) BOOL interactiveEnable;

@property (nonatomic, strong) YLDismissInteractiveTransition *dismissInteractive;

/// 黑色背景遮罩
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationWrappingView;
@end

@implementation YLModalTransitionManager

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        presentedViewController.transitioningDelegate = self;
    }
    return self;
}

#pragma mark - LifeCircle
// 呈现过渡即将开始的时候被调用的
- (void)presentationTransitionWillBegin {
    
    UIView *presentedViewControllerView = [super presentedView];
    
    /// 将圆角和阴影加在中间View上
    {
        UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.presentationWrappingView.bounds, UIEdgeInsetsMake(0, 0, 0, 0))];
        presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (self.radius) {
            if (!self.rectCorner) {
                self.rectCorner = UIRectCornerAllCorners;
            }
            [presentationRoundedCornerView yl_bezierPathRadius:self.radius corner:self.rectCorner];
        }
        
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, 0, 0))];
        presentedViewControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
        presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds;
    
        [presentedViewControllerWrapperView addSubview:presentedViewControllerView];
        [presentationRoundedCornerView addSubview:presentedViewControllerWrapperView];
        [self.presentationWrappingView addSubview:presentationRoundedCornerView];
    }
    
    [self.containerView addSubview:self.dimmingView];
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    if (!self.zoomScale) {
        self.zoomScale = 1;
    }
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.4f;
        self.presentingViewController.view.transform = CGAffineTransformScale(self.presentingViewController.view.transform, self.zoomScale, self.zoomScale);
    } completion:NULL];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) self.dimmingView = nil;
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed == YES) {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
    }
    self.interactiveEnable = NO;
}

/// 用于在过渡动画呈现结束时，设置被呈现的视图在容器视图中的位置
/// 该方法可以拿到弹出控制器的具体size(需要在弹出控制器中设置preferredContentSize),
/// 返回的frame可以在UIViewControllerAnimatedTransitioning协议中的
/// - (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext方法拿到
- (CGRect)frameOfPresentedViewInContainerView {
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.size.width = presentedViewContentSize.width;
    /// 可以直接在这里设置x.y点, 但是不太灵活 去- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext 方法中拿到frame后根据动画类型和frme大小设置xy;
//    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
//    presentedViewControllerFrame.origin.x = CGRectGetMaxX(containerViewBounds) - presentedViewContentSize.width;
    return presentedViewControllerFrame;
}


#pragma mark - Action
- (void)dimmingViewTapped:(UITapGestureRecognizer *)sender {
    self.interactiveEnable = NO;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)removeGestureRecognizerFromModalController {
    if (self.dismissGesture && [self.presentedViewController.view.gestureRecognizers containsObject:self.dismissGesture]) {
        [self.presentedViewController.view removeGestureRecognizer:self.dismissGesture];
        self.dismissGesture = nil;
    }
}

#pragma mark - Set
- (void)setDragable:(BOOL)dragable {
    _dragable = dragable;
    if (_dragable) {
        [self removeGestureRecognizerFromModalController];
        
        YLDirectionAbstractPanGesTureRecognizer *ges;
        switch (self.animationType) {
            case YLAnimationTypeTranslationLeft:
                ges = [[YLLeftPanGesTureRecognizer alloc] init];
                break;
            case YLAnimationTypeTranslationRight:
                ges = [[YLRightPanGesTureRecognizer alloc] init];
                break;
            case YLAnimationTypeTranslationTop:
                ges = [[YLTopPanGesTureRecognizer alloc] init];
                break;
            default:
                ges = [[YLBottomPanGesTureRecognizer alloc] init];
                break;
        }
        __weak __typeof(self)weakSelf = self;
        ges.dismissBlock = ^{
            weakSelf.interactiveEnable = YES;
            [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        };
        self.dismissGesture = ges;
        self.dismissGesture.agent = self;
        _dismissInteractive = [[YLDismissInteractiveTransition alloc] initWithGestureRecognizer:self.dismissGesture directionForDragging:self.animationType];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.dismissGesture addTarget:_dismissInteractive action:@selector(gestureRecognizeDidUpdate:)];
#pragma clang diagnostic pop
        [self.presentedViewController.view addGestureRecognizer:self.dismissGesture];
    } else {
        [self removeGestureRecognizerFromModalController];
    }
}

- (void)setContentScrollView:(UIScrollView *)scrollView {
    if (!self.dragable) {
        self.dragable = YES;
    }
    self.dismissGesture.scrollview = scrollView;
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/// 返回YES 第一个手势失败
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureRecognizerToFailPan && otherGestureRecognizer && self.gestureRecognizerToFailPan == otherGestureRecognizer) {
        return YES;
    }
    return NO;
}

/// 返回YES第二个手势失败
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UIViewController
//  When the presentation controller receives a
//  -viewWillTransitionToSize:withTransitionCoordinator: message it calls this
//  method to retrieve the new size for the presentedViewController's view.
//  The presentation controller then sends a
//  -viewWillTransitionToSize:withTransitionCoordinator: message to the
//  presentedViewController with this size as the first argument.
//
//  Note that it is up to the presentation controller to adjust the frame
//  of the presented view controller's view to match this promised size.
//  We do this in -containerViewWillLayoutSubviews.
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

#pragma mark - Get
- (UIView *)presentedView {
    return self.presentationWrappingView;
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.opaque = NO;
        _dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    }
    return _dimmingView;
}

- (UIView *)presentationWrappingView {
    if (!_presentationWrappingView) {
        _presentationWrappingView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
        [_presentationWrappingView shadowWithColor:nil radius:13 opacity:0.44 offset:CGSizeMake(0, 0) path:nil];
    }
    return _presentationWrappingView;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController * )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

/// 返回一个遵循UIViewControllerInteractiveTransitioning协议的类 用于实现手势驱动 present
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentGesture) {
        return [[YLPresentInteractiveTransition alloc] initWithGestureRecognizer:self.presentGesture directionForDragging:self.animationType];
    }
    return nil;
}

/// 返回一个遵循UIViewControllerInteractiveTransitioning协议的类 用于实现手势驱动 dismiss
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.interactiveEnable && self.dismissInteractive) {
        return self.dismissInteractive;
    }
    return nil;
}

/// 返回一个遵循UIViewControllerAnimatedTransitioning协议的类 用于实现present动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    YLAbstractAnimator *animator = [self animator];
    return animator;
}

/// 返回一个遵循UIViewControllerAnimatedTransitioning协议的类 用于实现dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (dismissed) {
        YLAbstractAnimator *animator = [self animator];
        return animator;
    }
    return nil;
}


#pragma mark - get
/// 根据动画类型返回具体的animator
- (YLAbstractAnimator *)animator {
    YLAbstractAnimator *_animator;
    switch (self.animationType) {
        case YLAnimationTypeTranslationBottom:
        case YLAnimationTypeTranslationLeft:
        case YLAnimationTypeTranslationRight:
        case YLAnimationTypeTranslationTop:
            /// 四个平移动画
            _animator = [[YLTranslationAnimator alloc] init];
            break;
        
        case YLAnimationTypeTransformCenter:
            /// 中心缩放动画
            _animator = [[YLTransformAnimator alloc] init];
            break;
            
        case YLAnimationTypeCrossDissolve:
            _animator = [[YLCrossDissolveAnimator alloc] init];
            break;
        default:
            _animator = [[YLAbstractAnimator alloc] init];
            break;
    }
    if (!self.duration) {
        self.duration = 0.3;
    }
    _animator.duration = self.duration;
    if (!self.damping) {
        self.damping = 1;
    }
    _animator.damping = self.damping;
    _animator.animationType = self.animationType;
    
    return _animator;
}

@end
