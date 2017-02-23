//
//  XWMessageSqliteTool.h
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMessage;
@interface XWMessageSqliteTool : NSObject

/// 回放 - 储存消息模型数组
+ (BOOL)saveOrUpdateIMs:(NSArray <IMessage *>*)IMs videoID:(NSString *)videoID;
/// 回放 - 按消息时间顺序提取消息模型数组
+ (NSMutableArray <IMessage *>*)getSortedIMessages:(NSString *)videoID;

/// 直播 - 存储收到的消息模型数组
+ (BOOL)saveLivingIMs:(NSArray <IMessage *>*)IMs videoID:(NSString *)videoID;
/// 直播 - 存储收到的单条消息模型
+ (BOOL)saveLivingOneIM:(IMessage *)IM videoID:(NSString *)videoID;
/// 直播 - 获取对应直播所有消息模型数组
+ (NSMutableArray <IMessage *>*)getLivedIMessages:(NSString *)videoID;
@end
