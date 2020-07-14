//
//  ConversationTextView.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ConversationInputServiceLogicTools : NSObject

@property (nonatomic ,assign) BOOL isShowToastMaxTip;//达到最大长度做 toast 提示
@property (nonatomic ,assign) NSInteger maxLength;//允许输入的文字最大长度:默认为 150
@property (nonatomic ,copy) void (^sendKeyHandler)(void);//发送按键事件
@property (nonatomic ,copy) void (^textDidChangeHandler)(void);//文字改变
@property (nonatomic ,assign ,readonly) CGFloat maxHeight;//输入框的最大高度：4行文字高度


@property (nonatomic ,strong) NSMutableAttributedString *parserString;
@property (nonatomic ,strong) NSMutableString *rawDataString;

//获取要传给后台的原始数据
- (NSString *)getTextViewRawData;

//计算富文本长度
+ (CGFloat)getAttributedStringLength:(NSAttributedString *)attributedText;
@end



@interface ConversationTextView : UITextView
@property (nonatomic ,strong ,readonly) ConversationInputServiceLogicTools *logicTools;
@property (nonatomic ,strong ,readonly) UILabel *placeholderLable;
@property (nonatomic ,strong) UIButton *emojiButton;
@property (nonatomic ,strong) NSString *placeholder;
@property (nonatomic ,assign) CGSize keyboardSize;//当前键盘的bounds

- (instancetype)initWithFrame:(CGRect)frame logic:(ConversationInputServiceLogicTools *)logicTools;

@end


NS_ASSUME_NONNULL_END






