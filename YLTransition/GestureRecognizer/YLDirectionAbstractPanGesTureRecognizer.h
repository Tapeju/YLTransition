//
//  YLDirectionAbstractPanGesTureRecognizer.h
//  
//
//  Created by TaPeJu on 2020/12/21.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <UIKit/UIKit.h>

/// 仅支持向特定方向滑动的手势识别器 (使用子类实例化)
@interface YLDirectionAbstractPanGesTureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, weak) UIScrollView *scrollview;

@property (nonatomic, assign) CGPoint panLocationStart;

/// 请使用该属性代替delegate, delegate属性内部使用
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> agent;

/// 子类内部使用
@property (nonatomic, strong, nullable) NSNumber *isFail;

/// 调用present / push的block
@property(nonatomic, copy) void (^beginBlock)(void);

@end

NS_ASSUME_NONNULL_END
