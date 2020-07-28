//
//  ConversationEmojiTools.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+ConversationEmoji.h"

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT NSString * const kConversationEmojiBundleName;//资源包
FOUNDATION_EXPORT NSString * const kConversationEmojiRegula;//检索 Emoji 的正则表达式
FOUNDATION_EXPORT NSUInteger const kConversationEmojiCount;//Emoji 表情数量
FOUNDATION_EXPORT NSString * getEmojiName(NSString * code);
FOUNDATION_EXPORT NSString * getEmojiCode(NSString * name);

@interface ConversationEmojiTools : NSObject

+ (NSDictionary *)getEmojiInfo;

//获取所有 Emoji 表情
+ (NSMutableArray<UIImage *> *)getAllEmojiImageArray;

//获取最近使用的 Emoji 表情
+ (NSMutableArray<UIImage *> *)getRecentlyUsedEmojiImageArray;

//存储使用的 Emoji
+ (BOOL)storeUsedEmoji:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END




