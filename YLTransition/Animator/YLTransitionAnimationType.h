//
//  YLTransitionAnimationType.h
//  
//
//  Created by TaPeJu on 2020/10/19.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#ifndef ModalAnimationType_h
#define ModalAnimationType_h

typedef NS_ENUM(NSUInteger, YLTransitionAnimationType) {
    /// 平移
    YLAnimationTypeTranslation,
    /// 中间缩放
    YLAnimationTypeTransformCenter,
    /// 淡入淡出
    YLAnimationTypeCrossDissolve,
    /// 抽屉
    YLAnimationTypeSlide,
};

typedef NS_ENUM(NSUInteger, YLAlignment) {
    YLAlignment_Top,
    YLAlignment_Left,
    YLAlignment_Bottom,
    YLAlignment_Right,
    YLAlignment_Center,
};

#endif /* ModalAnimationType_h */
