//
//  YLPresentInteractiveTransition.m
//  
//
//  Created by TaPeJu on 2020/12/14.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLPresentInteractiveTransition.h"
#import "YLDirectionAbstractPanGesTureRecognizer.h"

@interface YLPresentInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) YLDirectionAbstractPanGesTureRecognizer *gestureRecognizer;
@property (nonatomic, assign) YLAlignment direction;

@end

@implementation YLPresentInteractiveTransition

- (instancetype)initWithGestureRecognizer:(YLDirectionAbstractPanGesTureRecognizer *)gestureRecognizer directionForDragging:(YLAlignment)direction {
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _direction = direction;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:directionForDragging:" userInfo:nil];
}

- (void)dealloc {
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Save the transitionContext for later.
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}

- (void)gestureRecognizeDidUpdate:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:[self percentForGesture:gesture]];
    
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self finishInteractiveGesture:gesture];
    }
}


/// 获取滑动百分比
- (CGFloat)percentForGesture:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    UIView *containerView = _transitionContext.containerView;
    UIView *toView = [_transitionContext viewForKey:UITransitionContextToViewKey];

    /// 手指位置
    CGPoint location = [gesture locationInView:containerView.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat panLocationStart;
    if (self.direction == YLAlignment_Bottom || self.direction == YLAlignment_Top || self.direction == YLAlignment_Center) {
        panLocationStart = gesture.panLocationStart.y;
    } else {
        panLocationStart = gesture.panLocationStart.x;
    }
    
    CGFloat animationRatio = 0;
    if (self.direction == YLAlignment_Top) {
        animationRatio = (location.y - panLocationStart) / (CGRectGetHeight(toView.bounds));
    } else if (self.direction == YLAlignment_Right) {
        animationRatio = (panLocationStart - location.x) / (CGRectGetWidth(toView.bounds));
    } else if (self.direction == YLAlignment_Left) {
        animationRatio = (location.x - panLocationStart) / (CGRectGetWidth(toView.bounds));
    } else if (self.direction == YLAlignment_Bottom) {
        animationRatio = (panLocationStart - location.y) / (CGRectGetHeight(toView.bounds));
    } else if (self.direction == YLAlignment_Center) {
        animationRatio = (location.y - panLocationStart) / (CGRectGetHeight(toView.bounds));
    }
    
    return animationRatio;
}


/// 手势结束时结束手势驱动
- (void)finishInteractiveGesture:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    if ([self percentForGesture:gesture] >= 0.5f) {
        /// 滑动超过一半 完成手势驱动
        [self finishInteractiveTransition];
        return;
    }
    
    UIView *containerView = _transitionContext.containerView;
    /// 移动速度
    CGPoint velocity = [gesture velocityInView:containerView.window];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat velocityForSelectedDirection;
    if (self.direction == YLAlignment_Bottom || self.direction == YLAlignment_Top) {
        velocityForSelectedDirection = velocity.y;
    } else {
        velocityForSelectedDirection = velocity.x;
    }

    if (velocityForSelectedDirection > 100 &&
        (self.direction == YLAlignment_Left || self.direction == YLAlignment_Top)) {
        [self finishInteractiveTransition];
    } else if (velocityForSelectedDirection < -100 &&
               (self.direction == YLAlignment_Right  || self.direction == YLAlignment_Bottom )) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
}

@end
