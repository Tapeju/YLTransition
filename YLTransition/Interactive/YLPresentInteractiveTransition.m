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
@property (nonatomic, assign) YLTransitionAnimationType direction;

@end

@implementation YLPresentInteractiveTransition

- (instancetype)initWithGestureRecognizer:(YLDirectionAbstractPanGesTureRecognizer *)gestureRecognizer directionForDragging:(YLTransitionAnimationType)direction {
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _direction = direction;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:edgeForDragging:" userInfo:nil];
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
    __unused UIView *toView = [_transitionContext viewForKey:UITransitionContextToViewKey];
    __unused UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];

    /// 手指位置
    CGPoint location = [gesture locationInView:containerView.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat panLocationStart;
    if (self.direction == YLAnimationTypeTranslationBottom || self.direction == YLAnimationTypeTranslationTop) {
        panLocationStart = gesture.panLocationStart.y;
    } else {
        panLocationStart = gesture.panLocationStart.x;
    }
    
    CGFloat animationRatio = 0;
    if (self.direction == YLAnimationTypeTranslationTop) {
        animationRatio = (location.y - panLocationStart) / (CGRectGetHeight(containerView.bounds));
    } else if (self.direction == YLAnimationTypeTranslationRight) {
        animationRatio = (panLocationStart - location.x) / (CGRectGetWidth(containerView.bounds));
    } else if (self.direction == YLAnimationTypeTranslationLeft) {
        animationRatio = (location.x - panLocationStart) / (CGRectGetWidth(containerView.bounds));
    } else if (self.direction == YLAnimationTypeTranslationBottom) {
        animationRatio = (panLocationStart - location.y) / (CGRectGetHeight(containerView.bounds));
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
    if (self.direction == YLAnimationTypeTranslationBottom || self.direction == YLAnimationTypeTranslationTop) {
        velocityForSelectedDirection = velocity.y;
    } else {
        velocityForSelectedDirection = velocity.x;
    }

    if (velocityForSelectedDirection > 100 &&
        (self.direction == YLAnimationTypeTranslationLeft || self.direction == YLAnimationTypeTranslationTop)) {
        [self finishInteractiveTransition];
    } else if (velocityForSelectedDirection < -100 &&
               (self.direction == YLAnimationTypeTranslationRight  || self.direction == YLAnimationTypeTranslationBottom )) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
}

@end
