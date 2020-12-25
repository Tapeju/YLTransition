//
//  UIView+YLEffect.h
//
//
//  Created by TaPeJu on 2020/5/15.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
struct
YLCornerRadii {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
};
typedef struct YLCornerRadii CornerRadii;

CG_INLINE struct YLCornerRadii
YLCornerRadiiMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight) {
    struct YLCornerRadii cornerRadii;
    cornerRadii.topLeft = topLeft;
    cornerRadii.topRight = topRight;
    cornerRadii.bottomLeft = bottomLeft;
    cornerRadii.bottomRight = bottomRight;
    return cornerRadii;
}

@interface UIView (YLEffect)
#pragma mark - 圆角/边框
/// 为view添加不同大小的圆角
- (void)yl_radiusWithCornerRadii:(CornerRadii)CornerRadii;

/// 给View添加圆角
- (void)yl_radiusWithRadius:(CGFloat)radius
                  corner:(UIRectCorner)corner;

/// 给View添加圆角和边框
- (void)yl_radiusWithRadius:(CGFloat)radius
                  corner:(UIRectCorner)corner
             borderColor:(UIColor * _Nullable)borderColor
             borderWidth:(CGFloat)borderWidth;

/// 使用贝塞尔曲线添加圆角
- (void)yl_bezierPathRadius:(CGFloat)radius
                  corner:(UIRectCorner)corner;

/// 使用贝塞尔曲线添加圆角以及边框
- (void)yl_bezierPathRadiusWithRadius:(CGFloat)radius
                            corner:(UIRectCorner)corner
                       borderColor:(UIColor * _Nullable)borderColor
                       borderWidth:(CGFloat)borderWidth;

#pragma mark - 阴影
/// 添加一个阴影
/// @param color 阴影颜色
/// @param radius 模糊
/// @param opacity 透明
/// @param offset 阴影方向
/// @param path 阴影路径, 设置该值可避免离屏渲染
- (void)shadowWithColor:(UIColor * _Nullable)color
                 radius:(CGFloat)radius
                opacity:(CGFloat)opacity
                 offset:(CGSize)offset
                   path:(CGPathRef _Nullable)path;

@end

NS_ASSUME_NONNULL_END
