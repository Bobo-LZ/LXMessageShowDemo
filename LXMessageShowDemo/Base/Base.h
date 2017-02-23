//
//  Base.h
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#ifndef Base_h
#define Base_h

// 如果是调试模式(DEBUG 是调试模式下, 自带的宏)
#ifdef DEBUG
#define XMGLog(...) NSLog(__VA_ARGS__);
#else
#define XMGLog(...)
#endif

// 沙盒路径
#define kDocmentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject


// 打印调用函数的宏
#define XMGLogFunc XMGLog(@"%s",__func__);

// 随机颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define XMGColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define XMGAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define XMGRandomColor XMGColor(arc4random_uniform(255.0), arc4random_uniform(255.0), arc4random_uniform(255.0))
#define kCommonColor XMGColor(223, 223, 223)

// 屏幕尺寸相关
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 弱引用
#define kWeakSelf __weak typeof(self) weakSelf = self;

#endif /* Base_h */
