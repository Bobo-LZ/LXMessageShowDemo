//
//  IMessage.h
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  一条消息模型

#import <Foundation/Foundation.h>
#import "XWModelProtocol.h"
@interface IMessage : NSObject <XWModelProtocol>

@property (nonatomic, copy) NSString *IMID;
@property (nonatomic, copy) NSString *UID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *giftURL;
@property (nonatomic, assign) long IMDate;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *tidewayEmoji;


+(instancetype)initWith:(NSString *)IMID UID:(NSString *)UID content:(NSString *)content type:(NSString *)type;

@end
