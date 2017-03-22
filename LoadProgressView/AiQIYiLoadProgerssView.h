//
//  AiQIYiLoadProgerss.h
//  ProgressView
//
//  Created by zhaoName on 2017/3/16.
//  Copyright © 2017年 zhaoName. All rights reserved.
//  彷爱奇艺加载进度条

#import <UIKit/UIKit.h>

@interface AiQIYiLoadProgerssView : UIView

@property (nonatomic, assign) CGFloat animationDuration; /**<动画持续时长 默认1秒*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认2.0*/
@property (nonatomic, strong) UIColor *progressColor; /**< 进度条颜色 默认红色*/

/**
 *  添加通知 当程序重新进入前台或活跃状态，动画仍然会执行
 */
- (void)addNotificationObserver;

@end
