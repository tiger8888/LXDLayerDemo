//
//  LXDProgressLayer.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2515年 sindri lin. All rights reserved.
//

#import "LXDProgressLayer.h"
#import <UIKit/UIKit.h>

#define INIT_Y 76.f
#define MAX_LENGTH (CGRectGetWidth([UIScreen mainScreen].bounds) - 50)

@interface LXDProgressLayer ()

@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, assign) CGFloat maxOffset;

@end

@implementation LXDProgressLayer

- (instancetype)init
{
    if (self = [super init]) {
        self.strokeEnd = 1.f;
        self.maxOffset = 25.f;
        self.textRect = CGRectMake(5, INIT_Y - 30, 40, 20);
    }
    return self;
}

- (void)dealloc
{
    CGColorRelease(_strokeColor);
}

- (instancetype)initWithLayer: (LXDProgressLayer *)layer
{
    if (self = [super initWithLayer: layer]) {
    }
    return self;
}

- (void)setMaxOffset: (CGFloat)maxOffset
{
    _maxOffset = maxOffset;
    [self setNeedsDisplay];
}

- (void)setProgress: (CGFloat)progress
{
    _progress = MIN(1.f, MAX(0.f, progress));
    [self setNeedsDisplay];
}

- (void)setStrokeEnd: (CGFloat)strokeEnd
{
    _strokeEnd = MIN(1.f, MAX(0.f, strokeEnd));
    [self setNeedsDisplay];
}

- (void)setStrokeColor: (CGColorRef)strokeColor
{
    CGColorRelease(_strokeColor);
    _strokeColor = strokeColor;
    CGColorRetain(_strokeColor);        //必须进行这一步持有，否则对象将释放
    [self setNeedsDisplay];
}

- (void)drawInContext: (CGContextRef)ctx
{
    CGFloat midX = 25.f + MAX_LENGTH * _progress;
    CGFloat midY = _maxOffset * (1 - fabs((_progress - 0.5f) * 2)) + INIT_Y;
    CGFloat endX = midX, endY = midY;
    
    CGRect textRect = CGRectOffset(_textRect, MAX_LENGTH * _progress, _maxOffset * (1 - fabs(_progress - 0.5f) * 2));
    if (_report) {
        _report((NSUInteger)(_progress * 100), textRect, _strokeColor);
    }
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    CGPathMoveToPoint(linePath, NULL, 25, INIT_Y);
    if (_strokeEnd > _progress) {
        CGPathAddLineToPoint(linePath, NULL, midX, midY);
    } else {
        CGFloat scale = _strokeEnd / _progress;
        endX = (midX - 25.f) * scale + 25.f;
        endY = (midY - INIT_Y) * scale + INIT_Y;
        CGPathAddLineToPoint(linePath, NULL, endX, endY);
    }
    
    [self setPath: linePath onContext: ctx color: _strokeColor];
    CGContextStrokePath(ctx);
    
    CGMutablePathRef lastPath = CGPathCreateMutable();
    CGPathMoveToPoint(lastPath, NULL, endX, endY);
    if (endX != midX) {
        CGPathAddLineToPoint(lastPath, NULL, midX, midY);
    }
    CGPathAddLineToPoint(lastPath, NULL, 25.f + MAX_LENGTH, INIT_Y);
    [self setPath: lastPath onContext: ctx color: [UIColor colorWithRed: 204/255.f green: 204/255.f blue: 204/255.f alpha: 1.f].CGColor];
    CGContextStrokePath(ctx);
    
    
    CGPathRelease(lastPath);
    CGPathRelease(linePath);
}

- (void)setPath: (CGPathRef)path onContext: (CGContextRef)ctx color: (CGColorRef)color
{
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, 5.f);
    CGContextSetStrokeColorWithColor(ctx, color);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
}


@end
