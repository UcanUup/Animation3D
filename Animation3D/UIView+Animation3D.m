//
//  UIView+Animation3D.m
//  Animation3D
//
//  Created by 刘洋洋 on 16/8/22.
//  Copyright © 2016年 刘洋洋. All rights reserved.
//

#import "UIView+Animation3D.h"

#define CHANGE_ANGLE_TOTAL 90.0f //总共的动画角度
#define CHANGE_TIMES_PER_SECOND 45.0f //每秒动画次数
#define SEP_LEAN_ANGLE 80.0f //动画两个阶段

static CGFloat customLeanAngle = 0;
static void (^finishedCompletion)();


@implementation UIView (Animation3D)

+ (void)transition3DFromView:(UIView *)fromView toView:(UIView *)toView leanAngle:(CGFloat)leanAngle duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    customLeanAngle = leanAngle;
    [self transition3DFromView:fromView toView:toView duration:duration completion:completion];
}

+ (void)transition3DFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    if (!fromView || !toView) return;
    if (!fromView.superview || !toView.superview || fromView.superview != toView.superview) return;
    UIView *containerView = fromView.superview;
    
    finishedCompletion = completion;
    
    CGSize containerSize = containerView.bounds.size;
    CATransform3D transform = CATransform3DIdentity;
    CGFloat transformPos = containerSize.width / 2;
    
    transform = CATransform3DIdentity;
    fromView.layer.transform = transform;
    
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, transformPos, 0, -transformPos);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    toView.layer.transform = transform;
    
    CGFloat repeatTime = 1 / CHANGE_TIMES_PER_SECOND;
    NSDictionary *userInfo = @{@"fromView":fromView,@"toView":toView,@"containerView":containerView,@"transformPos":@(transformPos),@"duration":@(duration)};
    [NSTimer scheduledTimerWithTimeInterval:repeatTime target:self selector:@selector(animating:) userInfo:userInfo repeats:YES];
}

+ (void)animating:(NSTimer *)timer
{
    static CGFloat degree = 0;
    static BOOL timerStop = NO;
    
    NSDictionary *userInfo = [timer userInfo];
    UIView *fromView = [userInfo objectForKey:@"fromView"];
    UIView *toView = [userInfo objectForKey:@"toView"];
    UIView *containerView = [userInfo objectForKey:@"containerView"];
    CGFloat transformPos = [[userInfo objectForKey:@"transformPos"] floatValue];
    NSTimeInterval duration = [[userInfo objectForKey:@"duration"] doubleValue];
    
    CGFloat leanAngle = 0;
    CGFloat leanRadian = 0;
    if (customLeanAngle != 0) {
        leanAngle = [self leanAngleWithAngle:degree];
        leanRadian = M_PI / (180 / leanAngle);
    }
    
    CATransform3D transform = CATransform3DIdentity;
    if (customLeanAngle == 0) {
        transform.m34 = -1.0f / 500;
    } else {
        transform = CATransform3DRotate(transform, -M_PI / 180 * leanAngle, 1, 0, 0);
    }
    transform = CATransform3DTranslate(transform, 0, transformPos * sinf(leanRadian), -transformPos * cosf(leanRadian));
    transform = CATransform3DRotate(transform, -M_PI / 180 * degree, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, -transformPos * sinf(leanRadian), transformPos * cosf(leanRadian));
    containerView.layer.sublayerTransform = transform;
    
    if (timerStop) {
        [timer invalidate];
        timer = nil;
        degree = 0;
        timerStop = NO;
        
        transform = CATransform3DIdentity;
        containerView.layer.sublayerTransform = transform;
        fromView.layer.transform = transform;
        toView.layer.transform = transform;
        
        if (finishedCompletion) finishedCompletion();
    } else {
        degree += CHANGE_ANGLE_TOTAL / (duration * CHANGE_TIMES_PER_SECOND);
        if (degree >= CHANGE_ANGLE_TOTAL) {
            degree = CHANGE_ANGLE_TOTAL;
            timerStop = YES;
        }
    }
}

//自定义倾斜动画
+ (CGFloat)leanAngleWithAngle:(CGFloat)angle
{
    CGFloat leanAngle;
    CGFloat u, v, x;
    u = SEP_LEAN_ANGLE;
    v = customLeanAngle;
    x = angle;
    
    if (angle <= SEP_LEAN_ANGLE) {
        leanAngle = -v*(x-u)*(x-u)/(u*u)+v;
    } else {
        leanAngle = -v*(x-u)*(x-u)/((90-u)*(90-u))+v;
    }
    return leanAngle;
}

@end
