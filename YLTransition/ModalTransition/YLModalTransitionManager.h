//
//  YLModalTransitionManager.h
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTransitionAnimationType.h"

@class YLDirectionAbstractPanGesTureRecognizer;
@class YLAbstractAnimator;

NS_ASSUME_NONNULL_BEGIN

/// modal转场动画
@interface YLModalTransitionManager : UIPresentationController <UIViewControllerTransitioningDelegate>
/// 圆角大小
@property (nonatomic, assign) CGFloat radius;

/// 需要圆角的角 默认四个角
@property (nonatomic, assign) UIRectCorner rectCorner;

/// 是否需要回弹效果 数值越小 弹力越大 取值范围 0< x <=1 ,1为没有回弹 默认无特效
@property (nonatomic, assign) CGFloat damping;

/// 动画时间 如果设置0 则默认0.3
@property (nonatomic, assign) CGFloat duration;

/// 弹出控制器动画类型 
@property (nonatomic, assign) YLTransitionAnimationType animationType;

/// 背景图缩放比例取值0< x <=1 ,1为没有缩放 默认无特效
@property (nonatomic, assign) CGFloat zoomScale;

/// 用来Present的手势
@property (nullable, nonatomic, weak) YLDirectionAbstractPanGesTureRecognizer *presentGesture;

/// 弹出的控制器是否可以手势拖动Dismiss
@property (nonatomic, assign, getter=isDragable) BOOL dragable;

/// 优先响应的手势, 当该值被设置后, dismiss手势和该手势冲突时, 不响应dimiss手势
@property (nonatomic, assign) UIGestureRecognizer *gestureRecognizerToFailPan;

/// 如果Presnent出来的控制器是一个scrollView 并且想要支持拖动Dismiss 需要调这个方法
- (void)setContentScrollView:(UIScrollView *)scrollView;

/// present 时需要设置 用来确定弹出控制器的位置
@property (nonatomic, assign) YLAlignment viewAlignment;

/// 和viewAlignment一起使用 确定View的边距
@property (nonatomic) UIEdgeInsets viewEdgeInsets;

/// 自定义动画类
@property (nonatomic, strong) YLAbstractAnimator *customAnimator;

@end

NS_ASSUME_NONNULL_END
