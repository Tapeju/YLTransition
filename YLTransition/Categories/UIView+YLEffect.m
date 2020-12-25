//
//  UIView+YLEffect.m
//  
//
//  Created by TaPeJu on 2020/5/15.
//  Copyright © 2020 TaPeJu All rights reserved.
//

#import "UIView+YLEffect.h"

@implementation UIView (YLEffect)

#pragma mark - 圆角/边框
- (void)yl_radiusWithCornerRadii:(CornerRadii)CornerRadii {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPathRef path = YLPathCreateWithRoundedRect(self.bounds, CornerRadii);
    shapeLayer.path = path;
    CGPathRelease(path);
    self.layer.mask = shapeLayer;
}

- (void)yl_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    [self yl_radiusWithRadius:radius corner:corner borderColor:nil borderWidth:0];
}

- (void)yl_radiusWithRadius:(CGFloat)radius
                  corner:(UIRectCorner)corner
             borderColor:(UIColor * _Nullable)borderColor
             borderWidth:(CGFloat)borderWidth {
    self.layer.cornerRadius = radius;
    self.layer.maskedCorners = (CACornerMask)corner;
    if (borderColor) self.layer.borderColor = borderColor.CGColor;
    if (borderWidth > 0) self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

- (void)yl_bezierPathRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    [self yl_bezierPathRadiusWithRadius:radius corner:corner borderColor:nil borderWidth:0];
}

- (void)yl_bezierPathRadiusWithRadius:(CGFloat)radius
                            corner:(UIRectCorner)corner
                       borderColor:(UIColor * _Nullable)borderColor
                       borderWidth:(CGFloat)borderWidth {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    if (borderWidth > 0) path.lineWidth = borderWidth;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    if (borderColor) {
        maskLayer.strokeColor = borderColor.CGColor;
        maskLayer.fillColor = self.layer.backgroundColor;
    }
    self.layer.mask = maskLayer;
}

#pragma mark - 阴影
- (void)shadowWithColor:(UIColor * _Nullable)color
                 radius:(CGFloat)radius
                opacity:(CGFloat)opacity
                 offset:(CGSize)offset
                   path:(CGPathRef _Nullable)path; {
    if (color) self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (path) self.layer.shadowPath = path;
}



#pragma mark - private
//切圆角函数
CGPathRef YLPathCreateWithRoundedRect(CGRect bounds, CornerRadii cornerRadii) {
     const CGFloat minX = CGRectGetMinX(bounds);
     const CGFloat minY = CGRectGetMinY(bounds);
     const CGFloat maxX = CGRectGetMaxX(bounds);
     const CGFloat maxY = CGRectGetMaxY(bounds);
     
     const CGFloat topLeftCenterX = minX +  cornerRadii.topLeft;
     const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
     
     const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
     const CGFloat topRightCenterY = minY + cornerRadii.topRight;
     
     const CGFloat bottomLeftCenterX = minX +  cornerRadii.bottomLeft;
     const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
     
     const CGFloat bottomRightCenterX = maxX -  cornerRadii.bottomRight;
     const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
     //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
     
     CGMutablePathRef path = CGPathCreateMutable();
     //顶 左
     CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
     //顶 右
     CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
     //底 右
     CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight,0, M_PI_2, NO);
     //底 左
     CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
     CGPathCloseSubpath(path);
     return path;
}

@end
