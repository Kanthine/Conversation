//
//  ConversationInputBar.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationInputBar.h"
#import "NSObject+GetTheController.h"
#import "AlbumMainViewController.h"

@interface ConversationInputBar ()

{
    CGFloat _defaultHeight;
}

@property (nonatomic ,assign) BOOL isCanSendImage;//是否可以发送图片，默认为 YES
@property (nonatomic ,strong) UIButton *imageTypeButton;//选择图片
@property (nonatomic ,strong) UIButton *sendButton;//发送消息
@property (nonatomic ,strong) UIButton *coverButton;//背景蒙层

@end

@implementation ConversationInputBar

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _defaultHeight = 52.0f;
        
        self.frame = CGRectMake(0, getPageSafeAreaHeight(YES)  - _defaultHeight,CGRectGetWidth(UIScreen.mainScreen.bounds) , _defaultHeight);
        self.backgroundColor = UIColor.whiteColor;
        
        UIView *topLineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 0.5)];//顶部分割线
        topLineview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [self addSubview:topLineview];
        
        UIView *bottomLineview = [[UIView alloc] init];//底部分割线
        bottomLineview.tag = 10;
        bottomLineview.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [self addSubview:bottomLineview];

        
        self.isCanSendImage = YES;
        
        [self addSubview:self.textView];
        [self addSubview:self.sendButton];
        
        [self addObserverNotification];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self viewWithTag:10].frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
}

#pragma mark - Notification

//监测键盘的高度
- (void)addObserverNotification{
    __weak typeof(self) weakSelf = self;
    
    //键盘弹出，向输入框下层插入防误触遮罩
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        NSDictionary *info = [note userInfo];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGRect weakSelfFrame = weakSelf.frame;
        weakSelfFrame.origin.y = endKeyboardRect.origin.y - CGRectGetHeight(weakSelfFrame) - getNavigationBarHeight();
        weakSelf.frame = weakSelfFrame;
        if (weakSelf.frameChangeHandle) {
            weakSelf.frameChangeHandle(weakSelf.frame,0.0);
        }
        weakSelf.textView.keyboardSize = endKeyboardRect.size;
        [weakSelf.viewTheController.view addSubview:weakSelf.coverButton];
        [weakSelf.viewTheController.view insertSubview:weakSelf.coverButton belowSubview:weakSelf];
    }];
    
    //键盘消失，移除防误触遮罩
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        [weakSelf.coverButton removeFromSuperview];
        weakSelf.coverButton = nil;
    }];
    
    //键盘改变
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        NSDictionary *info = [note userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        weakSelf.textView.keyboardSize = endKeyboardRect.size;
        CGRect weakSelfFrame = weakSelf.frame;
        weakSelfFrame.origin.y = endKeyboardRect.origin.y - CGRectGetHeight(weakSelfFrame) - getNavigationBarHeight();
        [UIView animateWithDuration:duration animations:^{
            weakSelf.frame = weakSelfFrame;
        } completion:^(BOOL finished) {}];
        if (weakSelf.frameChangeHandle) {
            weakSelf.frameChangeHandle(weakSelfFrame,duration);
        }
    }];
}

/** 输入框文字改变，重置输入框高度、工具栏高度
 * 参数 isChangeImageTools：是否因为 插入\删除图片 引发布局重置
 */
- (void)textViewDidChangeResertFrame{
    [self updateSendButtonUI];
    
    if (_isCanSendImage == NO) {
        self.textView.frame = CGRectMake(12, 6, CGRectGetWidth(self.frame) - 12 - 50, CGRectGetHeight(self.textView.frame));
    }else{
        self.textView.frame = CGRectMake(50, 6, CGRectGetWidth(self.frame) - 50 * 2, CGRectGetHeight(self.textView.frame));
    }
    CGFloat height = CGRectGetMaxY(self.textView.frame) + 8;
    CGFloat maxY = CGRectGetMaxY(self.frame);
    height = height < _defaultHeight ? _defaultHeight : height;
    self.frame = CGRectMake(0, maxY - height, CGRectGetWidth(self.frame),height);
    //next：输入框宽度改变，高度可能会改变，所以需要去重置输入框高度、工具栏高度
    
    //重置输入框高度、工具栏高度
    CGFloat textWidth = self.textView.contentSize.width;
    CGFloat newHeight = [self.textView sizeThatFits:CGSizeMake(textWidth,MAXFLOAT)].height;
    CGFloat oldHeight = CGRectGetHeight(self.textView.frame);
    //只有高度差超过一行文字，再去重置；否则无意义
    if (fabs(oldHeight - newHeight) > 15.0) {
        //设置 textView 是否可滑动
        if (newHeight > self.textView.logicTools.maxHeight && self.textView.scrollEnabled == NO) {
            self.textView.scrollEnabled = YES;
        }else if(newHeight <= self.textView.logicTools.maxHeight && self.textView.scrollEnabled == YES) {
           self.textView.scrollEnabled = NO;
        }
        
        //设置最小最大值
        newHeight = newHeight < 36.0 ? 36.0 : newHeight;
        newHeight = newHeight > self.textView.logicTools.maxHeight ? self.textView.logicTools.maxHeight : newHeight;
        //重置 textView 高度
        CGRect textFrame = self.textView.frame;
        textFrame.size.height = newHeight;
        self.textView.frame = textFrame;
        
        //重置 self 坐标
        CGFloat maxY = CGRectGetMaxY(self.frame);
        CGFloat toolsViewHeight = CGRectGetMaxY(self.textView.frame) + 6;
        
        self.frame = CGRectMake(0, maxY - toolsViewHeight, CGRectGetWidth(UIScreen.mainScreen.bounds), toolsViewHeight);
    }
    
    if (self.frameChangeHandle) {
        self.frameChangeHandle(self.frame,0.0);
    }
    
    //两侧的按钮需要跟着重置
    _sendButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 50, CGRectGetHeight(self.frame) - 50, 50, 50);
    if (_imageTypeButton) {
        _imageTypeButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 50,50,50);
    }
}

#pragma mark - private method

- (void)updateSendButtonUI{
    NSString *content = [_textView.logicTools.getTextViewRawData copy];
    if (content.length == 0) {
        //判断字符串为空
        [_sendButton setImage:[UIImage imageNamed:@"conversation_input_send"] forState:UIControlStateNormal];
        _sendButton.userInteractionEnabled = NO;
    }else if ([[content  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
        //判断字符串只为空格
        [_sendButton setImage:[UIImage imageNamed:@"conversation_input_send"] forState:UIControlStateNormal];
        _sendButton.userInteractionEnabled = NO;
    }else{
        [_sendButton setImage:[UIImage imageNamed:@"conversation_input_send_highlight"] forState:UIControlStateNormal];
        _sendButton.userInteractionEnabled = YES;
    }
}

#pragma mark - public method

- (void)becomeResponder{
    [self.textView becomeFirstResponder];
}

- (void)resignKeyboardToolsFirstResponder{
    [_textView resignFirstResponder];
}

#pragma mark - response click

///发送图片按钮
- (void)imageButtonClick{
    if (PhotosManager.libraryAuthorization == NO) {
        [PhotosManager requestLibraryAuthorization];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    AlbumMainViewController *albumMainVC = [[AlbumMainViewController alloc] initWithAlbumResourcesType:AlbumResourcesTypeLibrary];
    albumMainVC.selectedImagesHanlder = ^(NSMutableArray<PHAsset *> *selectedArray) {
        if (selectedArray.count > 0) {
            PHAsset *assert = selectedArray.firstObject;
            
            if (weakSelf.sendImageHandle) {
                weakSelf.sendImageHandle(assert.originalImage);
            }
        }
    };
    [self.viewTheController presentViewController:albumMainVC animated:YES completion:nil];
}

/** 发送消息
 */
- (void)sendButtonCilck:(UIButton *)sender{
    //评论内容
    NSString *content = [_textView.logicTools.getTextViewRawData copy];
    CGFloat length = [ConversationInputServiceLogicTools getAttributedStringLength:_textView.attributedText];
    
    if (length == 0) {
        return ;//判断字符串为空
    }else if ([[content  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
        NSLog(@"都为空格");//判断字符串只为空格
        return ;
    }else if (length > 150) {
        NSLog(@"内容过长");
        return;
    }else{

    }
    if (self.sendCommentHandle) {
        self.sendCommentHandle(content);
    }
    _textView.text = @"";
    [self textViewDidChangeResertFrame];
}

#pragma mark - setter and getter

- (void)setIsCanSendImage:(BOOL)isCanSendImage{
    if (_isCanSendImage != isCanSendImage) {
        _isCanSendImage = isCanSendImage;
        
        if (isCanSendImage) {
            [self addSubview:self.imageTypeButton];
        }else{
            [_imageTypeButton removeFromSuperview];
            _imageTypeButton = nil;
        }
        [self textViewDidChangeResertFrame];
    }
}

- (UIButton *)coverButton{
    if (_coverButton == nil) {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverButton.frame = UIScreen.mainScreen.bounds;
        _coverButton.backgroundColor = UIColor.clearColor;
        [_coverButton addTarget:self action:@selector(resignKeyboardToolsFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (UIButton *)imageTypeButton{
    if (_imageTypeButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0,50,50);
        [button setImage:[UIImage imageNamed:@"conversation_input_send_image"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _imageTypeButton = button;
    }
    return _imageTypeButton;
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 50, 0,50,50);
        [button setImage:[UIImage imageNamed:@"conversation_input_send"] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.adjustsImageWhenDisabled = NO;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(sendButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton = button;
    }
    return _sendButton;
}

- (ConversationTextView *)textView{
    if (_textView == nil) {
        ConversationInputServiceLogicTools *logic = [[ConversationInputServiceLogicTools alloc] init];
        _textView = [[ConversationTextView alloc] initWithFrame:CGRectMake(12, 6,CGRectGetWidth(UIScreen.mainScreen.bounds) - 50 - 12,36) logic:logic];
        __weak typeof(self) weakSelf = self;
        //键盘发送按钮事件
        _textView.logicTools.sendKeyHandler = ^{
            [weakSelf sendButtonCilck:weakSelf.sendButton];
        };
        //输入框文本改变事件
        _textView.logicTools.textDidChangeHandler = ^{
            [weakSelf textViewDidChangeResertFrame];
        };
    }
    return _textView;
}

@end
