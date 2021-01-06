//
//  YLAbstractAnimator.h
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLTransitionAnimationType.h"

NS_ASSUME_NONNULL_BEGIN

/// 动画抽象类 不做任何动画 由子类实现动画 这里只提供属性和接口
@interface YLAbstractAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/// 是否需要回弹 数值越小 弹力越大  0为不需要回弹
@property (nonatomic, assign) CGFloat damping;

/// 动画时间 如果设置0 则默认0.3
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) YLAlignment viewAlignment;

@property (nonatomic) UIEdgeInsets viewEdgeInsets;

/// 动画的方向是否反转
@property (nonatomic, assign, getter=isReverse) BOOL reverse;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END
