//
//  ConversationDatabaseManager.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ConversationDatabaseManager.h"

@implementation ConversationDatabaseManager

/** sqlite 数据库路径
 */
+ (NSString *)sqliteFile{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/conversation.sqlite"];
}

+ (FMDatabaseQueue *)databaseQueue{
    static FMDatabaseQueue *databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (databaseQueue == nil){
            NSLog(@"sqliteFile ==== %@",ConversationDatabaseManager.sqliteFile);
            databaseQueue = [[FMDatabaseQueue alloc] initWithPath:ConversationDatabaseManager.sqliteFile];
        }
    });
    return databaseQueue;
}

/** 实例化一个全局任务队列，限定Operation并发量
 */
+ (NSOperationQueue *)shareThreadQueue{
    static NSOperationQueue *threadQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (threadQueue == nil){
            threadQueue = [[NSOperationQueue alloc] init];
            threadQueue.maxConcurrentOperationCount = 6;
            threadQueue.name = @"本地数据队列";
        }
    });
    return threadQueue;
}

/** 创建一张表
*/
+ (void)creatTableWithName:(NSString *)tableName sql:(NSString *)sql{
    [ConversationDatabaseManager databaseCurrentThreadInTransaction:^(FMDatabase *database, BOOL *rollback) {
        if (![database tableExists:tableName]){
            [database executeUpdate:sql];
        }
    }];
}

/** 销毁一张表
 */
+ (void)dropTableWithName:(NSString *)tableName{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
    [ConversationDatabaseManager databaseChildThreadInTransaction:^(FMDatabase *database, BOOL *rollback) {
        [database executeUpdate:sql];
    }];
}

+ (void)emptyTableWithName:(NSString *)tableName{
    NSString *dropSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
    [ConversationDatabaseManager databaseChildThreadInTransaction:^(FMDatabase *database, BOOL *rollback) {
        
        NSString *creatSql;
        
        FMResultSet *resultSet = database.getSchema;
        while ([resultSet next]){
            NSString *name = [resultSet stringForColumn:@"name"];
            if ([name isEqualToString:tableName]) {
                creatSql = [resultSet stringForColumn:@"sql"];
                break;
            }
        }
        [resultSet close];
        
        [database executeUpdate:dropSql];
        if (creatSql) {
            [database executeUpdate:creatSql];
        }
    }];
    
}

+ (void)databaseChildThreadInTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block{
    [[self shareThreadQueue] addOperationWithBlock:^{
        [ConversationDatabaseManager.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db setShouldCacheStatements:YES];
            block(db,rollback);
        }];
    }];
}

+ (void)databaseCurrentThreadInTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block{
    [ConversationDatabaseManager.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(db,rollback);
    }];
}


+ (void)clearSqlite{
    //如果还有针对数据库的操作，则全部取消
    if ([self shareThreadQueue].operationCount > 0){
        [[self shareThreadQueue] cancelAllOperations];
    }
    
    [ConversationDatabaseManager databaseChildThreadInTransaction:^(FMDatabase *database, BOOL *rollback) {
        NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
        
        FMResultSet *resultSet = database.getSchema;
        while ([resultSet next]){
            NSString *tbl_name = [resultSet stringForColumn:@"tbl_name"];
            NSString *sql = [resultSet stringForColumn:@"sql"];
            if (tbl_name && sql) {
                [muDict setObject:sql forKey:tbl_name];
            }
        }
        [resultSet close];
        
        [muDict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull tbl_name, NSString*  _Nonnull sql, BOOL * _Nonnull stop) {
            NSString *dropSql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tbl_name];
            [database executeUpdate:dropSql];
            [database executeUpdate:sql];
        }];
    }];
}

@end
