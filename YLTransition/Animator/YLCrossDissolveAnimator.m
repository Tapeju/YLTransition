//
//  YLCrossDissolveAnimator.m
//  
//
//  Created by TaPeJu on 2020/12/4.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLCrossDissolveAnimator.h"

@implementation YLCrossDissolveAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView {
    
    fromView.frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    
    CGPoint origin;
    if (!self.isReverse) {
        switch (self.viewAlignment) {
            case YLAlignment_Top:
            case YLAlignment_Left:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;

            case YLAlignment_Bottom:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMaxY(containerView.bounds) - CGRectGetHeight(toView.frame) - self.viewEdgeInsets.bottom);
                break;

            case YLAlignment_Right:
                origin = CGPointMake(CGRectGetWidth(containerView.bounds) - CGRectGetWidth(toView.frame) - self.viewEdgeInsets.right, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;

            case YLAlignment_Center:
                origin = CGPointMake(((CGRectGetMaxX(containerView.frame) - CGRectGetWidth(toView.frame)) / 2) + self.viewEdgeInsets.left, ((CGRectGetMaxY(containerView.frame) - CGRectGetHeight(toView.frame)) / 2) + self.viewEdgeInsets.top);
                break;

            default:
                origin =  CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;
        }
        CGRect frame = toView.frame;
        frame.origin = origin;
        toView.frame = frame;
    } else {
        switch (self.viewAlignment) {
            case YLAlignment_Top:
            case YLAlignment_Left:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;

            case YLAlignment_Bottom:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMaxY(containerView.bounds) - CGRectGetHeight(fromView.frame) - self.viewEdgeInsets.bottom);
                break;

            case YLAlignment_Right:
                origin = CGPointMake(CGRectGetWidth(containerView.bounds) - CGRectGetWidth(fromView.frame) - self.viewEdgeInsets.right, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;

            case YLAlignment_Center:
                origin = CGPointMake(((CGRectGetMaxX(containerView.frame) - CGRectGetWidth(fromView.frame)) / 2) + self.viewEdgeInsets.left, ((CGRectGetMaxY(containerView.frame) - CGRectGetHeight(fromView.frame)) / 2) + self.viewEdgeInsets.top);
                break;

            default:
                origin =  CGPointMake(CGRectGetMinX(containerView.bounds) + self.viewEdgeInsets.left, CGRectGetMinY(containerView.bounds) + self.viewEdgeInsets.top);
                break;
        }
        CGRect frame = fromView.frame;
        frame.origin = origin;
        fromView.frame = frame;
    }

    fromView.alpha = 1.0f;
    toView.alpha = 0.0f;

    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.alpha = 0.0f;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
