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
    /// 从底部平移
    YLAnimationTypeTranslation,
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
