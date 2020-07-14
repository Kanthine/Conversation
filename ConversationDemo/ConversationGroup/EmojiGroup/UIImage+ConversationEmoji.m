//
//  UIImage+ConversationEmoji.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "UIImage+ConversationEmoji.h"
#import "ConversationEmojiTools.h"
#import <objc/runtime.h>

@implementation UIImage (ConversationEmoji)

+ (UIImage *)imageEmojiName:(NSString *)name{
    NSString *code = getEmojiCode(name);
    UIImage *image = [UIImage imageEmojiCode:code];
    image.emojiName = name;
    return image;
}

+ (UIImage *)imageEmojiCode:(NSString *)code{
    NSString *imageName = [NSString stringWithFormat:@"%@/%@",kConversationEmojiBundleName,code];
    UIImage *image = [UIImage imageNamed:imageName];
    image.emojiCode = code;
    if (image == nil) {
        NSLog(@"code ======= %@",code);
    }
    return image;
}

- (NSString *)description{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:[NSString stringWithFormat:@"UIImage+ConversationEmoji : %p",self] forKey:@"address"];
    [dict setObject:[NSValue valueWithCGSize:self.size] forKey:@"size"];
    if (self.emojiName.length > 0) {
        [dict setObject:self.emojiName forKey:@"emojiName"];
    }
    if (self.emojiCode.length > 0) {
        [dict setObject:self.emojiCode forKey:@"emojiCode"];
    }
    return [NSString stringWithFormat:@"%@",dict];
    
}

#pragma mark - setter and getter

- (void)setEmojiName:(NSString *)emojiName{
    objc_setAssociatedObject(self, @selector(emojiName), emojiName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emojiName{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmojiCode:(NSString *)emojiCode{
    objc_setAssociatedObject(self, @selector(emojiCode), emojiCode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emojiCode{
    return objc_getAssociatedObject(self, _cmd);
}

@end
