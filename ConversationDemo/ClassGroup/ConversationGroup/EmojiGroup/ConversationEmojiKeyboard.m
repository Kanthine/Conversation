//
//  ConversationEmojiKeyboard.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//


#import "ConversationEmojiKeyboard.h"
#import "ConversationEmojiContentView.h"
#import "ConversationEmojiTools.h"

CGFloat const kConversationKeyboardToolsViewHeight = 44.0f;

@interface ConversationEmojiKeyboard ()
<ConversationEmojiContentViewDelegate>

@property (nonatomic ,strong ,readwrite) ConversationEmojiContentView *inputView;
@property (nonatomic ,strong ,readwrite) UIView *inputAccessoryView;
@property (nonatomic, strong, nullable) dispatch_queue_t loadQueue;

@property (nonatomic ,strong ) UIView *toolsView;

@end

@implementation ConversationEmojiKeyboard

//预加载表情数据
- (void)preLoadEmojiData{
    dispatch_async(self.loadQueue, ^{
        NSMutableArray *emojiArray = ConversationEmojiTools.getAllEmojiImageArray;;
        NSMutableArray *lastEmojiArray = [ConversationEmojiTools getRecentlyUsedEmojiImageArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.inputView loadEmojiData:emojiArray];
            [self.inputView reloadRecentlyData:lastEmojiArray];
        });
    });
}

- (void)showKeyboardSize:(CGSize)keyboardSize{
    [self.inputView showContentSize:keyboardSize toolsHeight:kConversationKeyboardToolsViewHeight];
    self.toolsView.frame = CGRectMake(0, keyboardSize.height - kConversationKeyboardToolsViewHeight, keyboardSize.width, kConversationKeyboardToolsViewHeight);
    [self.inputView addSubview:self.toolsView];
}

#pragma mark - DynamicExpressionContentViewDelegate

- (void)didSelectItem:(UIImage *)image{
    dispatch_async(self.loadQueue, ^{
        if ([ConversationEmojiTools storeUsedEmoji:image]) {
            NSMutableArray *lastEmojiArray = [ConversationEmojiTools getRecentlyUsedEmojiImageArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.inputView reloadRecentlyData:lastEmojiArray];
            });
        }
    });
    
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(didSelectEmojiItem:)]) {
        [self.keyboardDelegate didSelectEmojiItem:[image copy]];
    }
}


#pragma mark - response click

//选择 emoji 表情
- (void)emojiButtonClick{
    
}

- (void)deletebuttonClick{
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(didTapDeleteKeyClick)]) {
        [self.keyboardDelegate didTapDeleteKeyClick];
    }
}

#pragma mark - setter and getter

- (dispatch_queue_t)loadQueue{
    if (_loadQueue == nil) {
        _loadQueue = dispatch_queue_create("com.ConversationDemo.emoji", DISPATCH_QUEUE_SERIAL);
    }
    return _loadQueue;
}

- (ConversationEmojiContentView *)inputView{
    if (_inputView == nil) {
        _inputView = [[ConversationEmojiContentView alloc] init];
        _inputView.delegate = self;
    }
    return _inputView;
}

- (UIView *)inputAccessoryView{
    if (_inputAccessoryView == nil) {
        _inputAccessoryView = [[UIView alloc] init];
        _inputAccessoryView.backgroundColor = UIColor.clearColor;
    }
    //frame 可能被改变，此处重置 frame
    _inputAccessoryView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 0.1f);
    return _inputAccessoryView;
}

- (UIView *)toolsView{
    if (_toolsView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(UIScreen.mainScreen.bounds),kConversationKeyboardToolsViewHeight)];
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        
        UIButton *emojibutton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojibutton.frame = CGRectMake(0, 0, kConversationKeyboardToolsViewHeight, kConversationKeyboardToolsViewHeight);
        emojibutton.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [emojibutton setImage:[UIImage imageNamed:@"conversation_input_emoji_show"] forState:UIControlStateNormal];
        [emojibutton addTarget:self action:@selector(emojiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:emojibutton];
        
        UIButton *deletebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebutton.frame = CGRectMake( CGRectGetWidth(UIScreen.mainScreen.bounds) - kConversationKeyboardToolsViewHeight, 0, kConversationKeyboardToolsViewHeight, kConversationKeyboardToolsViewHeight);
        [deletebutton setImage:[UIImage imageNamed:@"conversation_input_emoji_delete"] forState:UIControlStateNormal];
        deletebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        deletebutton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        [deletebutton addTarget:self action:@selector(deletebuttonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deletebutton];
        
        _toolsView = view;
    }
    return _toolsView;
}

@end
