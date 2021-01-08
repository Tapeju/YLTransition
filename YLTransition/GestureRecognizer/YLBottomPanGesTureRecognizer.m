//
//  YLBottomPanGesTureRecognizer.m
//  
//
//  Created by TaPeJu on 2020/12/21.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "YLBottomPanGesTureRecognizer.h"

@implementation YLBottomPanGesTureRecognizer

#pragma mark - Override
- (BOOL)shouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [self velocityInView:self.view];
    return ((fabs(velocity.x) < fabs(velocity.y)) && velocity.y > 0);
}


#pragma mark - UIGestureRecognizerProtected
- (void)reset {
    [super reset];
    self.isFail = nil;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint velocity = [self velocityInView:self.view];
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];

    if (!self.scrollview) {
        if (((fabs(velocity.x) < fabs(velocity.y)) && velocity.y > 0)) {
            self.interactionInProgress = YES;
        }
        return;
    }
    
    if (self.isFail) {
        self.interactionInProgress = YES;
        if (self.isFail.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
            self.interactionInProgress = NO;
        }
        return;
    }

    CGPoint point = [touches.anyObject locationInView:self.scrollview];
    if (![self.scrollview pointInside:point withEvent:event]) {
        self.interactionInProgress = YES;
        return;
    }
    
    CGFloat bottomVerticalOffset = ceilf(-self.scrollview.contentInset.top);
    if ((fabs(velocity.x) < fabs(velocity.y)) && (nowPoint.y > prevPoint.y) && (self.scrollview.contentOffset.y <= bottomVerticalOffset)) {
        self.isFail = @NO;
        self.interactionInProgress = YES;
    } else if (self.scrollview.contentOffset.y >= bottomVerticalOffset) {
        self.state = UIGestureRecognizerStateFailed;
        self.isFail = @YES;
        self.interactionInProgress = NO;
    } else {
        self.isFail = @NO;
        self.interactionInProgress = YES;
    }
}

@end
