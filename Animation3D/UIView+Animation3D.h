//
//  UIView+Animation3D.h
//  Animation3D
//
//  Created by Young on 16/8/22.
//  Copyright © 2016年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Animation3D)

+ (void)transition3DFromView:(UIView *)fromView toView:(UIView *)toView leanAngle:(CGFloat)leanAngle duration:(NSTimeInterval)duration completion:(void (^)())completion;

+ (void)transition3DFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration completion:(void (^)())completion;

@end
