//
//  ConversationTextView.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationTextView.h"
#import "ConversationEmojiKeyboard.h"
#import "ConversationContentParserTool.h"

@interface ConversationInputServiceLogicTools ()
<UITextViewDelegate,ConversationEmojiKeyboardDelegate>

{
    BOOL _isMenuShow;
    BOOL _isTipLately;//记录最近是否提示过
    NSRange _textChangeRange;
}

@property (nonatomic ,weak) ConversationTextView *textView;
@property (nonatomic ,strong) UIFont *textFont;
@property (nonatomic ,strong) UIColor *textColor;

- (instancetype)initWithTextView:(ConversationTextView *)textView;

- (void)menuControllerPasteClick:(NSString *)paste;

@end

@implementation ConversationInputServiceLogicTools

- (instancetype)initWithTextView:(ConversationTextView *)textView
{
    self = [self init];
    if (self) {
        _textView = textView;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxLength = 150;
        _isShowToastMaxTip = YES;
        _textFont = [UIFont systemFontOfSize:15];
        _textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _maxHeight = _textFont.lineHeight * 4.5;//最大高度：文字的4行半
    }
    return self;
}

#pragma mark - ConversationEmojiKeyboardDelegate

/* 发送表情
 */
- (void)didSelectEmojiItem:(UIImage *)image{
    NSLog(@"发送表情 ==== %@",image);
    NSAttributedString *expressionString = [ConversationContentParserTool getExpressionAttributedWithString:image font:self.textView.font];
    [self insertAttributedStringInSelectedRange:expressionString];
}

/* 删除按键
 */
- (void)didTapDeleteKeyClick
{
    [self deleteCharactersInSelectedRange];
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(ConversationTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] && self.sendKeyHandler){
        self.sendKeyHandler();
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(ConversationTextView *)textView{
    if (textView.text.length > 0) {
        textView.placeholderLable.hidden = YES;
    }else{
        textView.placeholderLable.hidden = NO;
    }
    
    if (self.textDidChangeHandler){
        self.textDidChangeHandler();
    }
    
    //限制长度
    [self textDidChangeLengthLimit:textView];
}

#pragma mark - private method

- (NSString *)getTextViewRawData
{
    NSMutableString *rawDataString = [ConversationContentParserTool getRawDataWithString:_textView.attributedText];
    return rawDataString;
}

//删除光标前面的一个字符
- (CGFloat)deleteCharactersInSelectedRange
{
    NSUInteger location = self.textView.selectedRange.location;//光标位置
    if (self.textView.attributedText.length < location || location == 0) {
        NSLog(@"删除按键 ==== 越界");
    }else{
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        [string deleteCharactersInRange:NSMakeRange(location - 1, 1)];
        self.textView.attributedText = string;
        self.textView.selectedRange = NSMakeRange(location - 1, 0);
    }
    
    return 1;
//    return [DynamicInputServiceLogicTools getAttributedStringLength:self.textView.attributedText];
}

//在光标后面插入一段富文本
- (void)insertAttributedStringInSelectedRange:(NSAttributedString *)attributedString
{
    NSUInteger location = self.textView.selectedRange.location;//光标位置
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    [attributedText insertAttributedString:attributedString atIndex:location];
    _textView.attributedText = attributedText;
    [self textViewDidChange:_textView];
}

//限制文字长度
- (void)textDidChangeLengthLimit:(ConversationTextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];//高亮
//    if (!position) {//没高亮的文字
//        CGFloat ascLen = [DynamicInputServiceLogicTools getAttributedStringLength:self.textView.attributedText];//没高亮，获取长度
//        if (self.isShowToastMaxTip) {
//            if (ascLen > self.maxLength) {
//                [self tipTextLenght];
//            }
//        }
//        while (ascLen > self.maxLength) {
//            NSLog(@"ascLen === %f",ascLen);
//            ascLen = [self deleteCharactersInSelectedRange];
//        }
//    }
}

//最大长度超过限制，提示
- (void)tipTextLenght
{
    if (_isTipLately == NO) {
        _isTipLately = YES;
//        kPI(@"评论内容过长");
    }
    
    //1秒后重置，防止重复提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isTipLately = NO;
    });
}

- (void)menuControllerPasteClick:(NSString *)paste
{
    NSAttributedString *string = [ConversationContentParserTool transformAllInput:paste font:self.textFont color:self.textColor];
    [self insertAttributedStringInSelectedRange:string];
}

+ (CGFloat)getAttributedStringLength:(NSAttributedString *)attributedText
{
    return 1;
}

@end















@interface ConversationTextView ()
@property (nonatomic ,strong ,readwrite) UILabel *placeholderLable;
@property (nonatomic ,strong) ConversationEmojiKeyboard *expressionKeyboard;

@end


@implementation ConversationTextView

@synthesize keyboardSize = _keyboardSize;

//截取系统的粘贴事件
- (void)paste:(UIMenuController *)menu {

    NSString *paste = UIPasteboard.generalPasteboard.string;
    
    if (paste.length > 0) {
        
        [self.logicTools menuControllerPasteClick:paste];

    }
}

#pragma mark - system method

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame logic:(ConversationInputServiceLogicTools *)logicTools
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        _logicTools = logicTools;
        _logicTools.textView = self;
        self.delegate = self.logicTools;
        self.textContainerInset = UIEdgeInsetsMake(self.textContainerInset.top, 6, self.textContainerInset.bottom, CGRectGetWidth(self.emojiButton.frame));
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = CGRectGetHeight(frame) / 2.0;
        self.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        self.clipsToBounds = YES;
        self.placeholder = @"说点啥...";
        self.returnKeyType = UIReturnKeySend;
        self.scrollEnabled = NO;
        
        self.textColor = self.logicTools.textColor;
        self.font = self.logicTools.textFont;
        
        self.tintColor = [UIColor colorWithRed:255/255.0 green:122/255.0 blue:151/255.0 alpha:1];
        
        [self addSubview:self.placeholderLable];
        [self addSubview:self.emojiButton];

        [self.expressionKeyboard preLoadEmojiData];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_emojiButton) {
        CGFloat x = CGRectGetWidth(self.frame) + self.contentOffset.x - CGRectGetWidth(_emojiButton.frame);
        CGFloat y =  CGRectGetHeight(self.frame) - CGRectGetHeight(_emojiButton.frame) + self.contentOffset.y;
        _emojiButton.frame = CGRectMake(x,y, CGRectGetWidth(_emojiButton.frame), CGRectGetHeight(_emojiButton.frame));
    }
    _placeholderLable.frame = CGRectMake(10,8,CGRectGetWidth(self.frame) - CGRectGetWidth(_emojiButton.frame) - 10,20);

}

#pragma mark - response click

- (void)emojiButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.expressionKeyboard showKeyboardSize:self.keyboardSize];
        self.inputView = (UIView *)(self.expressionKeyboard.inputView);
        self.inputAccessoryView = (UIView *)(self.expressionKeyboard.inputAccessoryView);
    }else{
        self.inputView = nil;
        self.inputAccessoryView = nil;
    }
    
    [self reloadInputViews];
    
    if (self.isFirstResponder == NO) {
        [self becomeFirstResponder];
    }
}

#pragma mark - setter and getter

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (text == nil || [text isEqualToString:@""]) {
        self.placeholderLable.hidden = NO;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.textColor = self.logicTools.textColor;
    self.font = self.logicTools.textFont;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if ([_placeholder isEqualToString:placeholder] == NO) {
        _placeholder = placeholder;
        self.placeholderLable.text = placeholder;
    }
}

- (NSDictionary<NSString *,id> *)typingAttributes
{
    return @{NSFontAttributeName:self.logicTools.textFont,
             NSForegroundColorAttributeName:self.logicTools.textColor};
}

- (UILabel *)placeholderLable
{
    if (_placeholderLable == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,8,CGRectGetWidth(UIScreen.mainScreen.bounds),20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        _placeholderLable = label;
    }
    return _placeholderLable;
}

- (UIButton *)emojiButton
{
    if (_emojiButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 36);
        [button setImage:[UIImage imageNamed:@"conversation_input_emoji"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"conversation_input_keyboard"] forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 6);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [button addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _emojiButton = button;
    }
    return _emojiButton;
}

- (ConversationEmojiKeyboard *)expressionKeyboard{
    if (_expressionKeyboard == nil) {
        _expressionKeyboard = [[ConversationEmojiKeyboard alloc] init];
        _expressionKeyboard.keyboardDelegate = self.logicTools;
    }
    return _expressionKeyboard;
}

- (CGSize)keyboardSize
{
    if (_keyboardSize.width < CGRectGetWidth(UIScreen.mainScreen.bounds)) {
        _keyboardSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 260);
    }
    return _keyboardSize;
}

- (void)setKeyboardSize:(CGSize)keyboardSize
{
    if (_keyboardSize.height != keyboardSize.height) {
        _keyboardSize = keyboardSize;
        if (_expressionKeyboard) {
            [_expressionKeyboard showKeyboardSize:keyboardSize];
        }
    }
}

@end
