//
//  YLDismissInteractiveTransition.m
//  
//
//  Created by TaPeJu on 2020/12/18.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLDismissInteractiveTransition.h"
#import "YLDirectionAbstractPanGesTureRecognizer.h"

@interface YLDismissInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) YLDirectionAbstractPanGesTureRecognizer *gestureRecognizer;

@property (nonatomic, assign) CGFloat panLocationStart;

@end

@implementation YLDismissInteractiveTransition

- (instancetype)initWithGestureRecognizer:(YLDirectionAbstractPanGesTureRecognizer *)gestureRecognizer {
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:" userInfo:nil];
}

- (void)dealloc {
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Save the transitionContext for later.
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

/// 处理手势
- (void)gestureRecognizeDidUpdate:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self panLocationStartForGesture:gesture];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:[self percentForGesture:gesture]];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self finishInteractiveGesture:gesture];
    }
}

/// 设置手指开始滑动的位置
- (void)panLocationStartForGesture:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint location = [gesture locationInView:fromView.window];
    
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(gesture.view.transform));
    if (self.direction == YLAlignment_Bottom || self.direction == YLAlignment_Top || self.direction == YLAlignment_Center) {
        self.panLocationStart = location.y;
    } else {
        self.panLocationStart = location.x;
    }
}

/// 获取滑动百分比
- (CGFloat)percentForGesture:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint location = [gesture locationInView:fromView.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat animationRatio = 0;
    if (self.direction == YLAlignment_Bottom) {
        animationRatio = (location.y - self.panLocationStart) / (CGRectGetHeight(fromView.bounds));
    } else if (self.direction == YLAlignment_Left) {
        animationRatio = (self.panLocationStart - location.x) / (CGRectGetWidth(fromView.bounds));
    } else if (self.direction == YLAlignment_Right) {
        animationRatio = (location.x - self.panLocationStart) / (CGRectGetWidth(fromView.bounds));
    } else if (self.direction == YLAlignment_Top) {
        animationRatio = (self.panLocationStart - location.y) / (CGRectGetHeight(fromView.bounds));
    } else if (self.direction == YLAlignment_Center) {
        animationRatio = (location.y - self.panLocationStart) / (CGRectGetHeight(fromView.bounds));
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
    
    UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint velocity = [gesture velocityInView:fromView.window];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat velocityForSelectedDirection;
    
    if (self.direction == YLAlignment_Bottom || self.direction == YLAlignment_Top) {
        velocityForSelectedDirection = velocity.y;
    } else {
        velocityForSelectedDirection = velocity.x;
    }

    if (velocityForSelectedDirection > 100 &&
        (self.direction == YLAlignment_Right || self.direction == YLAlignment_Bottom)) {
        [self finishInteractiveTransition];
    } else if (velocityForSelectedDirection < -100 &&
               (self.direction == YLAlignment_Left || self.direction == YLAlignment_Top  || self.direction == YLAlignment_Center)) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
}

@end
