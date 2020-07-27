//
//  ConversationDatabaseManager.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationDatabaseManager : NSObject
/** 使用事务执行一些操作
 * 在分线程中执行
 */
+ (void)databaseChildThreadInTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block;

/** 使用事务执行一些操作
 * 在当前线程中执行（一般用于创建表时使用）
 */
+ (void)databaseCurrentThreadInTransaction:(void (^)(FMDatabase *database, BOOL *rollback))block;

/** 清空数据库
 */
+ (void)clearSqlite;

@end

NS_ASSUME_NONNULL_END
