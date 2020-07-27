//
//  UserManager.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nickName;//用户昵称
@property (nonatomic, strong) NSString *headPath;//用户头像
@property (nonatomic, strong) NSString *userId;//用户ID
@property (nonatomic, strong) NSString *token;//密码

@property (nonatomic, strong) NSString *account;//用户ID
@property (nonatomic, strong) NSString *password;//密码

@property (nonatomic ,assign) BOOL isGroup;


- (void)parserWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

+ (instancetype)shareUser;

- (BOOL)save;


+ (void)setRootController;

@end

NS_ASSUME_NONNULL_END
