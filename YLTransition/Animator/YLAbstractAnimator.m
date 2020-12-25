//
//  YLAbstractAnimator.m
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLAbstractAnimator.h"

@implementation YLAbstractAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (![transitionContext isAnimated]) return 0;
    return self.duration ? self.duration : 0.3;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

}

- (void)animationEnded:(BOOL)transitionCompleted {

}

@end
