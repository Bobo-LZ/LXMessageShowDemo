//
//  XWMessageSqliteTool.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/20.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWMessageSqliteTool.h"
#import "sqlite3.h"
#import "XWConst.h"
#import "Base.h"
#import "IMessage.h"
#import "XWModelTool.h"
#import "MJExtension.h"

@implementation XWMessageSqliteTool
sqlite3 *IMppDb = nil;

#pragma mark - 接口

/// 回放 - 储存消息模型数组
+ (BOOL)saveOrUpdateIMs:(NSArray <IMessage *>*)IMs videoID:(NSString *)videoID{
    
    if (![self isIMTableExists:videoID]) {
        [self createTableWithVideoID:videoID];
    }
    NSString *tableName = [self IMTableName:videoID];
    // 2. 检测表格是否需要更新, 需要, 更新
    if ([self isTableRequiredUpdate:[IMessage class] videoID:videoID]) {
        BOOL updateSuccess = [self updateTable:[IMessage class] videoID:videoID];
        if (!updateSuccess) {
            NSLog(@"更新数据库表结构失败");
            return NO;
        }
    }
    NSString *primaryKey = [IMessage primaryKey];
    NSMutableArray *insertAndUpdateSqls = [[NSMutableArray alloc] init];
    for (IMessage *message in IMs) {
        NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,primaryKey,message.IMID];
        NSArray *result = [self querySql:checkSql];
        if (result.count > 0) {
            //$ update 语句
            NSString *updateSql = [NSString stringWithFormat:@"update %@ set UID = '%@', content = '%@',type = '%@' ,giftURL = '%@',IMDate = '%zd',userName = '%@',tidewayEmoji = '%@' where %@ = '%@' ",tableName,message.UID,message.content,message.type,message.giftURL,message.IMDate,message.userName,message.tidewayEmoji, primaryKey,message.IMID];
            [insertAndUpdateSqls addObject:updateSql];
            
        }else{
            //$ insert 语句
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@(IMID, UID, content,type,giftURL,IMDate,userName,tidewayEmoji) values('%@','%@','%@','%@','%@','%zd','%@','%@')",tableName,message.IMID,message.UID,message.content,message.type,message.giftURL,message.IMDate,message.userName,message.tidewayEmoji];
            [insertAndUpdateSqls addObject:insertSql];
        }
    }
    return [self dealSqls:insertAndUpdateSqls];
}

/// 回放 - 按消息时间顺序提取消息模型数组
+ (NSMutableArray <IMessage *>*)getSortedIMessages:(NSString *)videoID{
    NSString *tableName = [self IMTableName:videoID];
    NSString *querySortedIMessageSql = [NSString stringWithFormat:@"select * from %@ order by IMDate",tableName];
    NSMutableArray *result = [self getIMessageSql:querySortedIMessageSql];
    return result;
}


/// 直播 - 存储收到的消息模型数组
+ (BOOL)saveLivingIMs:(NSArray <IMessage *>*)IMs videoID:(NSString *)videoID{
    if (![self isIMTableExists:videoID]) {
        [self createTableWithVideoID:videoID];
    }
    NSString *tableName = [self IMTableName:videoID];
    //检测表格是否需要更新, 需要, 更新
//    [self updateTableWithVideoID:videoID];
    NSString *primaryKey = [IMessage primaryKey];
    NSMutableArray *insertAndUpdateSqls = [[NSMutableArray alloc] init];
    for (IMessage *message in IMs) {
        NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,primaryKey,message.IMID];
        NSArray *result = [self querySql:checkSql];
        if (result.count == 0) {
            [insertAndUpdateSqls addObject:[self insertSQL:message tableName:tableName]];
        }
    }
    return [self dealSqls:insertAndUpdateSqls];
}

/// 直播 - 存储收到的单条消息模型
+ (BOOL)saveLivingOneIM:(IMessage *)message videoID:(NSString *)videoID{
    if (![self isIMTableExists:videoID]) {
        [self createTableWithVideoID:videoID];
    }
    NSString *tableName = [self IMTableName:videoID];
    //检测表格是否需要更新, 需要, 更新
    //    [self updateTableWithVideoID:videoID];
    NSString *primaryKey = [IMessage primaryKey];
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,primaryKey,message.IMID];
    NSArray *result = [self querySql:checkSql];
    if (result.count == 0) {
        return [self deal:[self insertSQL:message tableName:tableName]];
    }else{
        return YES;
    }
    
}
/// 直播 - 获取对应直播所有消息模型数组
+ (NSMutableArray <IMessage *>*)getLivedIMessages:(NSString *)videoID{
    NSString *tableName = [self IMTableName:videoID];
    NSString *querySortedIMessageSql = [NSString stringWithFormat:@"select * from %@",tableName];
    NSMutableArray *result = [self getIMessageSql:querySortedIMessageSql];
    return result;
}

#pragma mark - 私有方法
// 在某表中插入某条数据SQL语句
+(NSString *)insertSQL:(IMessage *)message tableName:(NSString *)tableName{
    return [NSString stringWithFormat:@"insert into %@(IMID, UID, content,type,giftURL,IMDate,userName,tidewayEmoji) values('%@','%@','%@','%@','%@','%zd','%@','%@')",tableName,message.IMID,message.UID,message.content,message.type,message.giftURL,message.IMDate,message.userName,message.tidewayEmoji];
}

+(BOOL)updateTableWithVideoID:(NSString *)videoID{
    // 2. 检测表格是否需要更新, 需要, 更新
    if ([self isTableRequiredUpdate:[IMessage class] videoID:videoID]) {
        BOOL updateSuccess = [self updateTable:[IMessage class] videoID:videoID];
        if (!updateSuccess) {
            NSLog(@"更新数据库表结构失败");
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

#pragma mark - 操作数据库
/// 处理单条SQL语句
+(BOOL)deal:(NSString *)sql{
    if (![self openIMDB]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    BOOL result = sqlite3_exec(IMppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    [self closeIMDB];
    return result;
}

/// 事务处理多条SQL语句
+(BOOL)dealSqls:(NSArray <NSString *>*)sqls{
    // 准备语句
    if (![self openIMDB]) {
        NSLog(@"打开IM数据库失败");
        return NO;
    }
    // 开启事务
    NSString *begin = @"begin transaction";
    sqlite3_exec(IMppDb, begin.UTF8String, nil, nil, nil);
    // 分布执行事务
    for (NSString *sql in sqls) {
        BOOL result = sqlite3_exec(IMppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
        if (!result) {
            // 处理失败回滚
            NSString *rollBack = @"rollback transaction";
            sqlite3_exec(IMppDb, rollBack.UTF8String, nil, nil, nil);
            [self closeIMDB];
            return NO;
        }
    }
    // 提交事务
    NSString *commit = @"commit transaction";
    sqlite3_exec(IMppDb, commit.UTF8String, nil, nil, nil);
    [self closeIMDB];
    return YES;
}

/// 开启数据库
+(BOOL)openIMDB{
    NSString *IMDBFileName = [kCachePath stringByAppendingPathComponent:kIMDBName];
    return sqlite3_open(IMDBFileName.UTF8String, &IMppDb) == SQLITE_OK;
}

/// 关闭数据库
+(void)closeIMDB{
    sqlite3_close(IMppDb);
}

/// 查询数据库中所有字段数据->返回字典
+(NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql{
    [self openIMDB];
    // 准备语句(预处理语句)
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(IMppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    // 3. 执行
    // 大数组
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -> 字典
        // 1. 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        // 2. 遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            // 2.1 获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 2.2 获取列值
            // 不同列的类型, 使用不同的函数, 进行获取
            // 2.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2 根据列的类型, 使用不同的函数, 进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                default:
                    break;
            }
            [rowDic setValue:value forKey:columnName];
        }
    }
    // 5. 释放资源
    sqlite3_finalize(ppStmt);
    [self closeIMDB];
    return rowDicArray;
}


/// 根据查询Sql语句提取数据库中消息模型数组
+(NSMutableArray <IMessage *>*)getIMessageSql:(NSString *)sql{
    [self openIMDB];
    // 准备语句(预处理语句)
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(IMppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    // 3. 执行
    // 大数组
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -> 字典
        // 1. 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        // 2. 遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            // 2.1 获取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            
            // 2.2 获取列值
            // 不同列的类型, 使用不同的函数, 进行获取
            // 2.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2 根据列的类型, 使用不同的函数, 进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                default:
                    break;
            }
            [rowDic setValue:value forKey:columnName];
        }
        IMessage *message = [IMessage mj_objectWithKeyValues:rowDic];
        [rowDicArray addObject:message];
    }
    // 5. 释放资源
    sqlite3_finalize(ppStmt);
    [self closeIMDB];
    return rowDicArray;
}

#pragma mark - 数据表相关
// 直播视频对应表名
+(NSString *)IMTableName:(NSString *)videoID{
    return [@"IMT_" stringByAppendingString:videoID];
}

/// 创建新表
+(BOOL)createTableWithVideoID:(NSString *)videoID{
    NSString *primaryKey = [IMessage primaryKey];
    // 1.2 获取一个模型里面所有的字段, 以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", [self IMTableName:videoID], [XWModelTool columnNamesAndTypesStr:[IMessage class]], primaryKey];
    return [self deal:createTableSql];
}


// 当前直播视频对应的表是否存在
+ (BOOL)isIMTableExists:(NSString *)videoID {
    NSString *tableName = [self IMTableName:videoID];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableArray *result = [self querySql:queryCreateSqlStr];
    return result.count > 0;
}

/// 判断当前表是否需要更新
+ (BOOL)isTableRequiredUpdate:(Class)cls videoID:(NSString *)videoID{
    // 1. 获取类对应的所有有效成员变量名称, 并排序
    NSArray *modelNames = [XWModelTool allTableSortedIvarNames:cls];
    // 2. 获取当前表格, 所有字段名称, 并排序
    NSArray *tableNames = [self tableSortedColumnNamesWithVideoID:videoID];
    // 3. 通过对比数据判定是否需要更新
    return ![modelNames isEqualToArray:tableNames];
}

/// 获取当前数据库表中所有字段
+ (NSArray *)tableSortedColumnNamesWithVideoID:(NSString *)videoID{
    NSString *tableName = [self IMTableName:videoID];
    // CREATE TABLE XWStu(age integer,stuNum integer,score real,name text, primary key(stuNum))
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableDictionary *dic = [self querySql:queryCreateSqlStr].firstObject;
    NSString *createTableSql = dic[@"sql"];
    if (createTableSql.length == 0) {
        return nil;
    }
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        if ([[nameType lowercaseString] containsString:@"primary"]) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        // age integer
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        [names addObject:name];
    }
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
}

/// 更新表格
+ (BOOL)updateTable:(Class)cls videoID:(NSString *)videoID {
    // 1. 创建一个拥有正确结构的临时表
    // 1.1 获取表格名称
    NSString *tmpTableName = [XWModelTool tmpTableName:cls];
    NSString *tableName = [self IMTableName:videoID];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *dropTmpTableSql = [NSString stringWithFormat:@"drop table if exists %@;", tmpTableName];
    [execSqls addObject:dropTmpTableSql];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [XWModelTool columnNamesAndTypesStr:cls], primaryKey];
    [execSqls addObject:createTableSql];
    // 2. 根据主键, 插入数据
    // insert into XWstu_tmp(stuNum) select stuNum from XWstu;
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    // 3. 根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [self tableSortedColumnNamesWithVideoID:videoID];
    NSArray *newNames = [XWModelTool allTableSortedIvarNames:cls];
    // 4. 获取更名字典
    NSDictionary *newNameToOldNameDic = @{};
    //  @{@"age": @"age2"};
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        // 找映射的旧的字段名称
        if ([newNameToOldNameDic[columnName] length] != 0) {
            oldName = newNameToOldNameDic[columnName];
        }
        // 如果老表包含了新的列明, 应该从老表更新到临时表格里面
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        // update 临时表 set 新字段名称 = (select 旧字段名 from 旧表 where 临时表.主键 = 旧表.主键)
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@);", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@;", tableName];
    [execSqls addObject:deleteOldTable];
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@;", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    return [self dealSqls:execSqls];
}



@end
