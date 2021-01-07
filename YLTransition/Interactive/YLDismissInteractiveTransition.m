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
@property (nonatomic, assign) YLAlignment direction;

@end

@implementation YLDismissInteractiveTransition

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

/// 处理手势
- (void)gestureRecognizeDidUpdate:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
     if (gesture.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:[self percentForGesture:gesture]];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self finishInteractiveGesture:gesture];
    }
}

/// 获取滑动百分比
- (CGFloat)percentForGesture:(YLDirectionAbstractPanGesTureRecognizer *)gesture {
    
    UIView *fromView = [_transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint location = [gesture locationInView:fromView.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(gesture.view.transform));
    
    CGFloat panLocationStart;
    if (self.direction == YLAlignment_Bottom || self.direction == YLAlignment_Top || self.direction == YLAlignment_Center) {
        panLocationStart = gesture.panLocationStart.y;
    } else {
        panLocationStart = gesture.panLocationStart.x;
    }
    
    CGFloat animationRatio = 0;
    if (self.direction == YLAlignment_Bottom) {
        animationRatio = (location.y - panLocationStart) / (CGRectGetHeight(fromView.bounds));
    } else if (self.direction == YLAlignment_Left) {
        animationRatio = (panLocationStart - location.x) / (CGRectGetWidth(fromView.bounds));
    } else if (self.direction == YLAlignment_Right) {
        animationRatio = (location.x - panLocationStart) / (CGRectGetWidth(fromView.bounds));
    } else if (self.direction == YLAlignment_Top) {
        animationRatio = (panLocationStart - location.y) / (CGRectGetHeight(fromView.bounds));
    } else if (self.direction == YLAlignment_Center) {
        animationRatio = (location.y - panLocationStart) / (CGRectGetHeight(fromView.bounds));
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
