//
//  YLTransitionAnimationType.h
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#ifndef ModalAnimationType_h
#define ModalAnimationType_h


/// 需要增加动画样式可以增加这个枚举, 然后实现具体的动画效果即可
typedef NS_ENUM(NSUInteger, YLTransitionAnimationType) {
    /// 从底部平移
    YLAnimationTypeTranslationBottom,
    /// 从左边平移
    YLAnimationTypeTranslationLeft,
    /// 从右边平移
    YLAnimationTypeTranslationRight,
    /// 从上边平移
    YLAnimationTypeTranslationTop,
    /// 从中间缩放
    YLAnimationTypeTransformCenter,
    /// 淡入淡出
    YLAnimationTypeCrossDissolve,
};

typedef NS_ENUM(NSUInteger, YLAlignment) {
    YLAlignment_Top,
    YLAlignment_Left,
    YLAlignment_Bottom,
    YLAlignment_Right,
    YLAlignment_Center,
};

#endif /* ModalAnimationType_h */
