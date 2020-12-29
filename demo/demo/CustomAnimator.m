//
//  CustomAnimator.m
//  demo
//
//  Created by Ton on 2020/12/28.
//

#import "CustomAnimator.h"

@implementation CustomAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    BOOL isPush = ([toViewController.navigationController.viewControllers indexOfObject:toViewController] > [fromViewController.navigationController.viewControllers indexOfObject:fromViewController]);
    BOOL isPresentOrPush = isPush || isPresenting;
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];/// 动画做完之后的frame
    [containerView addSubview:toView];
    
    if (isPresentOrPush) {
        /// 出现前的frem
        CGPoint origin;
        origin = CGPointMake(CGRectGetMinX(containerView.bounds), -CGRectGetMaxY(toView.bounds));
        origin.x += self.viewEdgeInsets.left;
        origin.y += self.viewEdgeInsets.top;
        
        toViewInitialFrame.origin = origin;
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
        
    } else {
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, -CGRectGetHeight(fromView.frame));
    }
    
    /// 动画
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresentOrPush)
            toView.frame = toViewFinalFrame;
        else
            fromView.frame = fromViewFinalFrame;

    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
