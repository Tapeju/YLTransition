//
//  YLTransformAnimator.m
//  
//
//  Created by TaPeJu on 2020/10/20.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLTransformAnimator.h"

@implementation YLTransformAnimator

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
    CGRect __unused toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    [containerView addSubview:toView];
    
    if (isPresentOrPush) {
        CGPoint origin = CGPointMake((CGRectGetMaxX(containerView.frame) - CGRectGetWidth(toViewFinalFrame)) / 2, (CGRectGetMaxY(containerView.frame) - CGRectGetHeight(toViewFinalFrame)) / 2);
        toViewInitialFrame.origin = origin;
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
        toView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } else {
        fromViewFinalFrame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2, 0, 0);
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    
    [UIView animateWithDuration:transitionDuration delay:0 usingSpringWithDamping:self.damping initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if (isPresentOrPush)
            toView.transform = CGAffineTransformMakeScale(1, 1);
        else
            fromView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
