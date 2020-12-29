//
//  YLPresentInteractiveTransition.h
//  
//
//  Created by TaPeJu on 2020/12/14.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTransitionAnimationType.h"
@class YLDirectionAbstractPanGesTureRecognizer;

NS_ASSUME_NONNULL_BEGIN

/// Present/Push 交互手势
@interface YLPresentInteractiveTransition : UIPercentDrivenInteractiveTransition
- (instancetype)initWithGestureRecognizer:(YLDirectionAbstractPanGesTureRecognizer *)gestureRecognizer directionForDragging:(YLAlignment)direction NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
