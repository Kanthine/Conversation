//
//  ConversationContentParserTool.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/19.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationEmojiTools.h"

NS_ASSUME_NONNULL_BEGIN

//检索图片的正则表达式
FOUNDATION_EXPORT NSString * const kConversationImageLinkRegula;
//检索网页的正则表达式
FOUNDATION_EXPORT NSString * const kConversationWebLinkRegula;
//检索电话号码的正则表达式
FOUNDATION_EXPORT NSString * const kConversationPhoneNumberRegula;
///转换时间
FOUNDATION_EXPORT NSString *transformChatTime(NSString *theTime);
/* 动态内容添加的表情键
 * 键值：@{@"1":@"[发呆]"}
 */
UIKIT_EXTERN NSAttributedStringKey const NSConversationEmojiAttributeName;


/* 动态内容添加的链接键
 * 使用系统的 NSLinkAttributeName ，还需要更改默认的文字样式，太过麻烦;
 * 对应的值是一个 DynamicContentLinkValueModel 模型类
 */
UIKIT_EXTERN NSAttributedStringKey const NSConversationContentLinkAttributeName;

//高亮的颜色
#define kDynamicHighlightedLinkColor [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1.0]


typedef NS_ENUM(NSUInteger ,ConversationContentLinkType) {
    ConversationContentLinkTypeImage = 0,//图片类型
    ConversationContentLinkTypeWeb,//网页
    ConversationContentLinkTypePhoneNumber,//电话号码
};


/* 链接信息类
 * 富文本属性 NSConversationContentLinkAttributeName 键对应的值
 */
@interface ConversationContentLinkValueModel : NSObject
@property (nonatomic ,readonly ,assign) ConversationContentLinkType linkType;//链接类型
@property (nonatomic ,readonly ,strong) NSString *url;//链接
@property (nonatomic ,readonly ,strong) NSDictionary *otherInfo;//额外信息
+ (instancetype)initializeWithLinkType:(ConversationContentLinkType)linkType url:(NSString *)url;
+ (instancetype)initializeWithLinkType:(ConversationContentLinkType)linkType url:(NSString *)url otherInfo:(NSDictionary *)otherInfo;
@end




@interface ConversationContentParserTool : NSObject

/* 解析原始文本
 */
+ (NSMutableAttributedString *)parserContentWithText:(NSString *)text showImage:(BOOL)isShow font:(UIFont *)font color:(UIColor *)color;

/* 剔除字符串中的图片
 */
+ (NSMutableString *)filterOutImageLink:(NSString *)text;

@end


/* 输出框中的文字处理
 */
@interface ConversationContentParserTool (Input)

/* 将输入的文本转为富文本
 * 特殊格式： @某人、表情符号、话题，其余不处理
 */
+ (NSMutableAttributedString *)transformAllInput:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

+ (NSMutableAttributedString *)transformAllAttributedInput:(NSAttributedString *)text font:(UIFont *)font color:(UIColor *)color;

/* 将输入框的富文本完整还原为字符串
 */
+ (NSMutableString *)getRawDataWithString:(NSAttributedString *)parserString;

@end

/* Emoji 表情
 */
@interface ConversationContentParserTool (Emoji)
/* 将 Emoji 表情 转为 富文本
 * fontHeight ：富文本中文字高度
 */
+ (NSAttributedString *)getExpressionAttributedWithString:(UIImage *)image font:(UIFont *)font;
+ (NSAttributedString *)getEmojiWithName:(NSString *)name font:(UIFont *)font;

@end


NS_ASSUME_NONNULL_END
