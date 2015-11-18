//
//  LXDGradientViewController.m
//  LXDLayerDemo
//
//  Created by 林欣达 on 15/11/18.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import "LXDGradientViewController.h"

@interface LXDGradientViewController ()

@property (nonatomic, strong) CAGradientLayer * gradientLayer;

@end

@implementation LXDGradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectMake(50, 80, CGRectGetWidth(self.view.bounds) - 100, 160)];
    imageView.image = [UIImage imageNamed: @"test"];
    
    self.gradientLayer.mask = imageView.layer;
    [self.view.layer addSublayer: self.gradientLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changePercent:(UISlider *)sender
{
    _gradientLayer.locations = @[@(sender.value), @(sender.value)];
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectInset(self.view.bounds, 0, 80);
        _gradientLayer.colors = @[
                                  (id)[UIColor blackColor].CGColor,
                                  (id)[UIColor blueColor].CGColor
                                  ];
        _gradientLayer.locations = @[@0, @0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}


@end
