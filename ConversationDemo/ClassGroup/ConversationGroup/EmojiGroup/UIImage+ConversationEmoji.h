//
//  UIImage+ConversationEmoji.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ConversationEmoji)

@property (nonatomic ,strong) NSString *emojiName;
@property (nonatomic ,strong) NSString *emojiCode;

+ (UIImage *)imageEmojiName:(NSString *)name;
+ (UIImage *)imageEmojiCode:(NSString *)code;

+ (UIImage *)imageConversationBack:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
