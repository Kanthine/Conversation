//
//  ConversationUserModel.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationUserModel : NSObject
@property (nonatomic, strong) NSString *nickName;//用户昵称
@property (nonatomic, strong) NSString *headPath;//用户头像
@property (nonatomic, strong) NSString *userId;//用户ID
@property (nonatomic, strong) NSString *account;//用户账号
@property (nonatomic ,assign) BOOL isGroup;//是否是群组

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end



@interface ConversationUserModel (DAO)

@end



NS_ASSUME_NONNULL_END
