//
//  YLTranslationAnimator.m
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLTranslationAnimator.h"

@implementation YLTranslationAnimator

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
        switch (self.animationType) {
            case YLAnimationTypeTranslationTop:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds), -CGRectGetMaxY(toView.bounds));
                break;
                
            case YLAnimationTypeTranslationLeft:
                origin = CGPointMake(-CGRectGetWidth(toView.bounds), CGRectGetMinY(containerView.bounds));
                break;
                
            case YLAnimationTypeTranslationBottom:
                origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
                toViewFinalFrame = CGRectOffset(toViewFinalFrame, 0, CGRectGetHeight(containerView.frame) - CGRectGetHeight(toViewFinalFrame));
                break;
                
            case YLAnimationTypeTranslationRight:
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
        switch (self.animationType) {
            case YLAnimationTypeTranslationTop:
                fromViewFinalFrame = CGRectOffset(fromView.frame, 0, -CGRectGetHeight(fromView.frame));
                break;
                
            case YLAnimationTypeTranslationLeft:
                fromViewFinalFrame = CGRectOffset(fromView.frame, -CGRectGetWidth(fromView.frame), 0);
                break;
                
            case YLAnimationTypeTranslationBottom:
                fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
                break;
                
            case YLAnimationTypeTranslationRight:
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
        if (isPresentOrPush)
            toView.frame = toViewFinalFrame;
        else
            fromView.frame = fromViewFinalFrame;

    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
    /// 这个动画效果使用手势驱动时不太跟手 
//    [UIView animateWithDuration:transitionDuration delay:0 usingSpringWithDamping:self.damping initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//        if (isPresentOrPush)
//            toView.frame = toViewFinalFrame;
//        else
//            fromView.frame = fromViewFinalFrame;
//
//    } completion:^(BOOL finished) {
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        [transitionContext completeTransition:!wasCancelled];
//    }];
    

}

@end