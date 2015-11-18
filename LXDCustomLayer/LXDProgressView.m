//
//  LXDProgressView.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "LXDProgressView.h"

@interface LXDProgressView ()

@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) LXDProgressLayer * progressLayer;

@end


@implementation LXDProgressView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        
        self.progressLayer = [LXDProgressLayer layer];
        self.progressLayer.strokeColor = [UIColor colorWithRed: 66/255.f green: 1.f blue: 66/255.f alpha: 1.f].CGColor;
        self.progressLayer.frame = self.bounds;
        __weak UILabel * weakLbl = self.progressLabel;
        self.progressLayer.report = ^(NSUInteger progress, CGRect textRect, CGColorRef textColor) {
            NSString * progressStr = [NSString stringWithFormat: @"%lu%%", progress];
            weakLbl.text = progressStr;
            weakLbl.frame = textRect;
            weakLbl.textColor = [UIColor colorWithCGColor: textColor];
        };
        self.progressLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer: self.progressLayer];
        [self addSubview: self.progressLabel];
    }
    return self;
}

- (void)setProgress: (CGFloat)progress
{
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
    self.progressLayer.progress = progress;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _progressLabel.font = [UIFont systemFontOfSize: 13.f];
        
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}


@end
