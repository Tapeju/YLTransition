//
//  YLTranslationAnimator.m
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLTranslationAnimator.h"

@implementation YLTranslationAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView {
    
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];/// 动画做完之后的frame
    
    
    if (!self.isReverse) {
        /// 出现前的frem
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
                origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
                break;
        }
        toViewInitialFrame.origin = origin;
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
        
    } else {
        /// 消失时的frame
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
        
    }
    
    /// 动画
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (!self.isReverse)
            toView.frame = toViewFinalFrame;
        else
            fromView.frame = fromViewFinalFrame;

    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
