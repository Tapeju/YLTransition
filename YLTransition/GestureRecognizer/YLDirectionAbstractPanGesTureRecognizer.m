//
//  YLDirectionAbstractPanGesTureRecognizer.m
//  
//
//  Created by TaPeJu on 2020/12/21.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLDirectionAbstractPanGesTureRecognizer.h"
#import "YLTopPanGesTureRecognizer.h"
#import "YLLeftPanGesTureRecognizer.h"
#import "YLBottomPanGesTureRecognizer.h"
#import "YLRightPanGesTureRecognizer.h"

@interface YLDirectionAbstractPanGesTureRecognizer ()


@end

@implementation YLDirectionAbstractPanGesTureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.delegate = self;
        [self addTarget:self action:@selector(handle:)];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        [self addTarget:self action:@selector(handle:)];
    }
    return self;
}

- (void)handle:(YLDirectionAbstractPanGesTureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (self.beginBlock) {
            self.beginBlock();
        }
    }
}

#pragma mark - private
/// 子类实现具体功能用来区分滑动方向
- (BOOL)shouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.agent respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
        return [self.agent gestureRecognizerShouldBegin:gestureRecognizer] & [self shouldBegin:gestureRecognizer];
    }
    return [self shouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldReceivePress:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldReceivePress:press];;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveEvent:(UIEvent *)event API_AVAILABLE(ios(13.4), tvos(13.4)) {
    if ([self.agent respondsToSelector:@selector(gestureRecognizer:shouldReceiveEvent:)]) {
        return [self.agent gestureRecognizer:gestureRecognizer shouldReceiveEvent:event];
    }
    return YES;
}


#pragma mark - UIGestureRecognizerProtected
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint panLocationStart = [touches.anyObject locationInView:self.view.window];
    self.panLocationStart = panLocationStart;
}



@end
