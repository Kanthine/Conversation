//
//  ConversationEmojiKeyboard.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConversationEmojiKeyboardDelegate <NSObject>

/* 发送表情
 */
- (void)didSelectEmojiItem:(UIImage *)image;

/* 删除按键
 */
- (void)didTapDeleteKeyClick;

@end




/* 动态 表情 自定义键盘
 *
 */
@class ConversationEmojiContentView;

@interface ConversationEmojiKeyboard : NSObject

@property (nonatomic ,weak) id <ConversationEmojiKeyboardDelegate> keyboardDelegate;
@property (nonatomic ,strong ,readonly) ConversationEmojiContentView *inputView;
@property (nonatomic ,strong ,readonly) UIView *inputAccessoryView;
- (void)showKeyboardSize:(CGSize)keyboardSize;
- (void)preLoadEmojiData;
@end


NS_ASSUME_NONNULL_END
