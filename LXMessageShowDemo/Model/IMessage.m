//
//  IMessage.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "IMessage.h"
#import "MJExtension.h"

@implementation IMessage

+(instancetype)initWith:(NSString *)IMID UID:(NSString *)UID content:(NSString *)content type:(NSString *)type{
    IMessage *message = [[IMessage alloc] init];
    message.IMID = IMID;
    message.UID = UID;
    message.content = content;
    message.type = type;
    return message;
}

+(NSString *)primaryKey{
    return @"IMID";
}

+(instancetype)initWithDict:(NSDictionary *)dict{
    return [self mj_objectWithKeyValues:dict];
}


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"IMID" : @"id"
             };
}

@end
