//
//  TGFlashingView.m
//  ToGoDecoration
//
//  Created by tugou on 2018/11/19.
//  Copyright © 2018年 tugou.com. All rights reserved.
//

#import "TGFlashingView.h"

#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@implementation TGFlashingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *dotView = [[UIView alloc] initWithFrame:self.bounds];
//        dotView.backgroundColor = DefaultColorGray204;
        dotView.layer.cornerRadius = 2.5;
        [dotView.layer addAnimation:self.alphaAnimation forKey:@"alpha"];
        [self addSubview:dotView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.cornerRadius = 2.5;
    layer.backgroundColor = ColorWithAlpha(255, 255, 255, 0.5).CGColor;
    [layer addAnimation:self.scaleAnimation forKey:@"scale"];
    [self.layer addSublayer:layer];
}

- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1); // 开始时的倍率
    animation.toValue = @(2.8); // 结束时的倍率
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    animation.duration = 0.5f;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE; // 重复次数
    animation.removedOnCompletion = NO;
    return animation;
}

- (CABasicAnimation *)alphaAnimation {
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5f;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE; // 重复次数
    animation.removedOnCompletion = NO;
    return animation;
}

@end
