//
//  YLTransformAnimator.m
//  
//
//  Created by TaPeJu on 2020/10/20.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLTransformAnimator.h"

@implementation YLTransformAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView {
    
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    if (!self.isReverse) {
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
        
        if (!self.isReverse)
            toView.transform = CGAffineTransformMakeScale(1, 1);
        else
            fromView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}


@end
