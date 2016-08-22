//
//  ViewController.m
//  Animation3D
//
//  Created by 刘洋洋 on 16/7/22.
//  Copyright © 2016年 刘洋洋. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Animation3D.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _containerView.bounds = self.view.bounds;
    
    [UIView transition3DFromView:_imageView toView:_imageView2 leanAngle:0 duration:1.0f completion:nil];
}

@end
