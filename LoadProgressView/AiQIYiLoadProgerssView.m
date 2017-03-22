//
//  AiQIYiLoadProgerss.m
//  ProgressView
//
//  Created by zhaoName on 2017/3/16.
//  Copyright © 2017年 zhaoName. All rights reserved.
//  彷爱奇艺加载进度条

#import "AiQIYiLoadProgerssView.h"

#define AIQIYI_LOAD_WIDTH self.frame.size.width
#define AIQIYI_LOAD_HEIGHT self.frame.size.height

@interface AiQIYiLoadProgerssView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer; /**< */

@end

@implementation AiQIYiLoadProgerssView

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    if([super init])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}

#pragma mark -- 初始化数据

/** 初始化数据*/
- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    self.animationDuration = 1.5;
    self.progressWidth = 2.0;
    self.progressColor = [UIColor redColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addAnimation];
}

#pragma mark -- 进度条

- (void)drawRect:(CGRect)rect
{
    if(AIQIYI_LOAD_WIDTH != AIQIYI_LOAD_HEIGHT) return;
    // 画背景圆
//    UIBezierPath *cyclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(AIQIYI_LOAD_WIDTH * 0.5, AIQIYI_LOAD_HEIGHT * 0.5) radius:(AIQIYI_LOAD_WIDTH - self.progressWidth) * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    [cyclePath setLineWidth:self.progressWidth];
//    [cyclePath stroke];
    
    // 画三角形
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    CGFloat triangleHeight = AIQIYI_LOAD_WIDTH / 3.0;
    [trianglePath moveToPoint:CGPointMake(triangleHeight * 2 + self.progressWidth, AIQIYI_LOAD_HEIGHT * 0.5)];
    [trianglePath addLineToPoint:CGPointMake(triangleHeight + self.progressWidth, AIQIYI_LOAD_HEIGHT * 0.5 - triangleHeight * 0.5)];
    [trianglePath addLineToPoint:CGPointMake(triangleHeight + self.progressWidth, AIQIYI_LOAD_HEIGHT * 0.5 + triangleHeight * 0.5)];
    
    [self.progressColor setFill];
    [trianglePath fill];
}

- (void)addAnimation
{
    [self.layer removeAllAnimations];
    // 添加旋转动画
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAni.duration = self.animationDuration;
    rotationAni.fromValue = 0;
    rotationAni.toValue = @(M_PI *2);
    rotationAni.repeatCount = MAXFLOAT;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:rotationAni forKey:@"rotation"];
    
    // strokeEnd 正向画出路径
    CABasicAnimation *endAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue = @0.0;
    endAni.toValue = @1.0;
    endAni.duration = self.animationDuration;
    endAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // strokeStart 反向清除路径
    CABasicAnimation *startAni = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAni.fromValue = @0.0;
    startAni.toValue = @1.0;
    startAni.duration = self.animationDuration;
    startAni.beginTime = self.animationDuration;
    startAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAni, startAni];
    group.repeatCount = MAXFLOAT;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2*self.animationDuration;
    // 上面的正向画出路径和反向清楚路径动画 是根据你画图是的起点来的
    UIBezierPath *cyclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(AIQIYI_LOAD_WIDTH * 0.5, AIQIYI_LOAD_HEIGHT * 0.5) radius:(AIQIYI_LOAD_WIDTH - self.progressWidth) * 0.5 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    self.shapeLayer.path = cyclePath.CGPath;
    
    [self.shapeLayer addAnimation:group forKey:@"group"];
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark -- 进入前台或活跃状态

// 当程序重新进入前台或活跃状态，动画仍然会执行
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- getter

- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = self.progressWidth;
        _shapeLayer.strokeColor = self.progressColor.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapeLayer;
}

@end
