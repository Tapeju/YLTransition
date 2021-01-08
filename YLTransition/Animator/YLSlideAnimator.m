//
//  YLSlideAnimator.m
//  demo
//
//  Created by Ton on 2021/1/8.
//

#import "YLSlideAnimator.h"

@implementation YLSlideAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView {
    if(self.reverse){
        [self executeReverseAnimation:transitionContext
                               fromVC:fromVC
                                 toVC:toVC
                             fromView:fromView
                               toView:toView
                        containerView:containerView];
    } else {
        [self executeForwardsAnimation:transitionContext
                                fromVC:fromVC toVC:toVC
                              fromView:fromView
                                toView:toView
                         containerView:containerView];
    }
}

- (void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
                         fromVC:(UIViewController *)fromVC
                           toVC:(UIViewController *)toVC
                       fromView:(UIView *)fromView
                         toView:(UIView *)toView
                  containerView:(UIView *)containerView {
    
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toVC];
    
    if (!fromView) {
        fromView = fromVC.view;
    }

    /// 设置fromView的最终显示Frame
    
    switch (self.viewAlignment) {
        case YLAlignment_Top:
            fromViewFinalFrame = CGRectOffset(fromViewFinalFrame, 0, CGRectGetHeight(toViewFinalFrame));
            break;
            
        case YLAlignment_Left:
            fromViewFinalFrame = CGRectOffset(fromViewFinalFrame, CGRectGetWidth(toViewFinalFrame), 0);
            break;
            
        case YLAlignment_Bottom:
            fromViewFinalFrame = CGRectOffset(fromViewFinalFrame, 0, - CGRectGetHeight(toViewFinalFrame));
            break;
            
        case YLAlignment_Right:
            fromViewFinalFrame = CGRectOffset(fromViewFinalFrame, - CGRectGetWidth(toViewFinalFrame), 0);
            break;
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"YLAnimationTypeSlide NOT support YLAlignment_Center" userInfo:nil];
            break;
    }
    
    
    
    CGPoint origin;
    switch (self.viewAlignment) {
        case YLAlignment_Top:
            origin = CGPointMake(CGRectGetMinX(containerView.bounds), -CGRectGetMaxY(toView.bounds));
            break;
            
        case YLAlignment_Left:
            origin = CGPointMake(-CGRectGetWidth(toView.bounds), CGRectGetMinY(containerView.bounds));
            break;
            
        case YLAlignment_Bottom:
            origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
            toViewFinalFrame = CGRectOffset(toViewFinalFrame, 0, CGRectGetHeight(containerView.frame) - CGRectGetHeight(toViewFinalFrame));
            break;
            
        case YLAlignment_Right:
            origin = CGPointMake(CGRectGetWidth(containerView.bounds), CGRectGetMinY(containerView.bounds));
            toViewFinalFrame = CGRectOffset(toViewFinalFrame, CGRectGetWidth(containerView.frame) - CGRectGetWidth(toViewFinalFrame), 0);
            break;
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"YLAnimationTypeSlide NOT support YLAlignment_Center" userInfo:nil];
            break;
    }
    toViewInitialFrame.origin = origin;
    toViewInitialFrame.size = toViewFinalFrame.size;
    toView.frame = toViewInitialFrame;

    
    /// 动画
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        toView.frame = toViewFinalFrame;
        fromView.frame = fromViewFinalFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
                        fromVC:(UIViewController *)fromVC
                          toVC:(UIViewController *)toVC
                      fromView:(UIView *)fromView
                        toView:(UIView *)toView
                 containerView:(UIView *)containerView {

    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    
    if (!toView) {
        toView = toVC.view;
    }
    
    switch (self.viewAlignment) {
        case YLAlignment_Top:
            fromViewFinalFrame = CGRectOffset(fromView.frame, 0, -CGRectGetHeight(fromView.frame));
            break;
            
        case YLAlignment_Left:
            fromViewFinalFrame = CGRectOffset(fromView.frame, -CGRectGetWidth(fromView.frame), 0);
            break;
            
        case YLAlignment_Bottom:
            fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
            break;
            
        case YLAlignment_Right:
            fromViewFinalFrame = CGRectOffset(fromView.frame, CGRectGetWidth(fromView.frame), 0);
            break;
            
        default:
            fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
            break;
    }
    
    /// 动画
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        toView.frame = toViewFinalFrame;
        fromView.frame = fromViewFinalFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
