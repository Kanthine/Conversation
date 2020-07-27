//
//  ConversationInputBar.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationTextView.h"

NS_ASSUME_NONNULL_BEGIN

/* 输入框
 */
@interface ConversationInputBar : UIView

@property (nonatomic ,copy) void(^sendCommentHandle)(NSString *text);
@property (nonatomic ,copy) void(^sendImageHandle)(UIImage *image);
@property (nonatomic ,copy) void(^frameChangeHandle)(CGRect frame,CGFloat duration);
@property (nonatomic ,strong) ConversationTextView *textView;//输入框


/* 响应输入框，弹出键盘
 */
- (void)becomeResponder;

/* 输入框失去响应，键盘消失
 */
- (void)resignKeyboardToolsFirstResponder;

@end

NS_ASSUME_NONNULL_END
