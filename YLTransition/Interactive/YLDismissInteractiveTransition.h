//
//  YLDismissInteractiveTransition.h
//  
//
//  Created by TaPeJu on 2020/12/18.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLTransitionAnimationType.h"
@class YLDirectionAbstractPanGesTureRecognizer;

NS_ASSUME_NONNULL_BEGIN

/// Present/Push 交互手势
@interface YLDismissInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(YLDirectionAbstractPanGesTureRecognizer *)gestureRecognizer directionForDragging:(YLTransitionAnimationType)direction NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
