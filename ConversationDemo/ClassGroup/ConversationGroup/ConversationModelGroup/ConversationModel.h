//
//  ConversationModel.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConversationStatusDefine.h"
NS_ASSUME_NONNULL_BEGIN

// {"content":"DVD’s","fromHeaderPath":"/pic/default.jpg","fromID":"1594972271962-364","fromName":"774792381@qq.com","group":true,"msgType":"Text","time":"2020-07-30 11:06:52","toHeaderPath":"/pic/default.jpg","toID":"happy_group","toName":"开心聊天群"}


@interface ConversationModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *fromID;
@property (nonatomic, strong) NSString *fromName;
@property (nonatomic, strong) NSString *fromHeaderPath;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *msgType;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, assign) NSInteger sendDate;

@property (nonatomic, strong) NSString *toName;
@property (nonatomic, strong) NSString *toHeaderPath;
@property (nonatomic, strong) NSString *toID;

@property (nonatomic, assign) BOOL group;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
@end





@interface ConversationModel (Extend)
@property (nonatomic ,assign) CGSize contentSize;
@property (nonatomic ,assign) CGFloat cellHeight;
@property (nonatomic, strong) NSAttributedString *attributedString;

- (ConversationDirection)direction;
- (ConversationType)type;


- (void)parserExtraInfo;
@end



@class ConversationUserModel;
@interface ConversationModel (DAO)

/** 插入数据
 */
+ (void)insertModel:(ConversationModel *)model;
+ (void)insertModels:(NSMutableArray<ConversationModel *> *)modelArray;

/** 获取所有消息
 */
+ (void)getAllModels:(void(^)(NSMutableArray<ConversationModel *> *modelsArray))block;

/** 获取某个对象相关的所有消息
 */
+ (void)getModelsWithTarget:(ConversationUserModel *)target complete:(void(^)(NSMutableArray<ConversationModel *> *modelsArray))block;

/** 获取最新消息
 */
+ (void)getLastModelWithTarget:(ConversationUserModel *)target complete:(void(^)(ConversationModel *lastModel))block;

@end


NS_ASSUME_NONNULL_END
