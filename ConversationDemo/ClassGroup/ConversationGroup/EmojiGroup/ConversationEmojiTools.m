//
//  ConversationEmojiTools.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationEmojiTools.h"

/* 检索 Emoji 的正则表达式:
 * 检索 [字符] 格式
 * 字符为 纯汉字 | 纯字母，长度在 1-3 之间
 */
NSString * const kConversationEmojiRegula = @"(?<=\\[)(([\u4e00-\u9fa5]{1,3})|([a-zA-Z]{1,3}))(?=\\])";
NSString * const kConversationEmojiBundleName = @"ConversationResource.bundle";
NSUInteger const kConversationEmojiCount = 71;

NSString * getEmojiName(NSString * code){
    NSDictionary *dict = ConversationEmojiTools.getEmojiInfo;
    if ([dict.allKeys containsObject:code]) {
        return dict[code];
    }
    return @"";
}

NSString * getEmojiCode(NSString * name){
    NSDictionary<NSString *, NSString *> *dict = ConversationEmojiTools.getEmojiInfo;
    
    if ([dict.allValues containsObject:name]) {
        __block NSString *code = @"";
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            if ([value isEqualToString:name]) {
                code = key;
                * stop = YES;
            }
        }];
        return code;
    }
    return @"";
}


@implementation ConversationEmojiTools

//获取所有的 Emoji 表情
+ (NSDictionary<NSString *, NSString *> *)getEmojiInfo{
    NSBundle *emojiBundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:@"ConversationResource" ofType:@"bundle"]];
    NSString *infoPath = [emojiBundle pathForResource:@"Conversation_Emoji/ConversatioEmoji" ofType:@"plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:infoPath];
    return plistDict;
}

//获取最近使用的的 Emoji 表情
+ (NSMutableArray<NSDictionary<NSString *, NSString *> *> *)getRecentlyEmojiInfo{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/recentlyEmoji.plist"];
    NSMutableArray *recentlyUsedArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    return recentlyUsedArray;
}

+ (NSMutableArray<UIImage *> *)getAllEmojiImageArray{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:kConversationEmojiCount];
    [ConversationEmojiTools.getEmojiInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIImage *image = [UIImage imageEmojiCode:key];
        image.emojiName = obj;
        if (image) {
            [imageArray addObject:image];
        }
    }];
    NSSortDescriptor *codeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"emojiCode" ascending:YES];
    [imageArray sortUsingDescriptors:@[codeDescriptor]];
    return imageArray;
}

//获取最近使用的 Emoji 表情
+ (NSMutableArray<UIImage *> *)getRecentlyUsedEmojiImageArray{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:kConversationEmojiCount];
    [[ConversationEmojiTools getRecentlyEmojiInfo] enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [UIImage imageEmojiCode:obj.allKeys.firstObject];
        image.emojiName = obj.allValues.firstObject;
        [imageArray addObject:image];
    }];
    return imageArray;

}

//存储使用的 Emoji
+ (BOOL)storeUsedEmoji:(UIImage *)image{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/recentlyEmoji.plist"];
    NSMutableArray<NSDictionary *> *recentlyUsedArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (recentlyUsedArray == nil) {
        recentlyUsedArray = [NSMutableArray arrayWithCapacity:1];
        [recentlyUsedArray addObject:@{image.emojiCode:image.emojiName}];
    }else{
        
        __block NSInteger lastIndex = -1;
        [recentlyUsedArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.allKeys.firstObject isEqualToString:image.emojiCode]) {
                lastIndex = idx;
                *stop = YES;
            }
        }];
        
        if (lastIndex == 0) {
             return NO;
        }else if (lastIndex > 0){
            [recentlyUsedArray exchangeObjectAtIndex:0 withObjectAtIndex:lastIndex];
        }else{
            [recentlyUsedArray insertObject:@{image.emojiCode:image.emojiName} atIndex:0];
        }
        
        if (recentlyUsedArray.count > 7) {
            [recentlyUsedArray removeLastObject];
        }
    }
    BOOL result = [recentlyUsedArray writeToFile:filePath atomically:YES];
    return result;
}

@end
