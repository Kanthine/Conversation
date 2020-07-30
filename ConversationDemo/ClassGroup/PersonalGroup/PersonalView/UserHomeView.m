//
//  UserHomeView.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserHomeView.h"



@interface FMNavbarView ()
{
    CGFloat _start_Y;
}
@end

@implementation FMNavbarView

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), getNavigationBarHeight())];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _start_Y = isIPhoneNotchScreen() ? 44 : 20;
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.titleLable];
        [self addSubview:self.backButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

#pragma mark - setter and getters

- (UIButton *)backButton{
    if (_backButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.frame = CGRectMake(0, _start_Y, 60, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [button setImage:[UIImage imageNamed:@"bookDetaile_navbar_left"] forState:UIControlStateNormal];
        _backButton = button;
    }
    return _backButton;
}

- (UILabel *)titleLable{
    if (_titleLable == nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, _start_Y + 13, CGRectGetWidth(UIScreen.mainScreen.bounds) - 30 * 2.0, 18)];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = UIColor.whiteColor;
        _titleLable = label;
    }
    return _titleLable;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 44, _start_Y, 44, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        _rightButton = button;
    }
    return _rightButton;
}

@end





















@interface UserHomeTableHeaderView ()
{
    CGFloat _headerHeight;
}
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIImageView *portraitImageView;
@end

@implementation UserHomeTableHeaderView

- (instancetype)init{

    self = [super init];
    if(self){
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.backImageView];
        [self addSubview:self.contentView];
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        self.frame = CGRectMake(0, isIPhoneNotchScreen() ? -44 : -20,width, 184 / 375.0 * width + 45);
        
        self.backImageView.frame = CGRectMake(0, 0, width, 184 / 375.0 * width);
        
        self.contentView.frame = CGRectMake(12,CGRectGetMaxY(self.backImageView.frame) - 40,width - 12 * 2.0,80);

        self.portraitImageView.frame = CGRectMake(14, -30,68, 68);
        CGFloat nick_X = CGRectGetMaxX(self.portraitImageView.frame) + 12;
        self.nickNameButton.frame = CGRectMake(nick_X, 12,160, 20);
        _headerHeight = CGRectGetHeight(self.frame);
    }
    return self;
}

#pragma mark - public method

- (void)reloadData:(UserManager *)userModel{
    [self.nickNameButton setTitle:userModel.nickName forState:UIControlStateNormal];
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userModel.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
}

- (void)updateLayoutByOffset:(CGFloat)yOffset{
    if (yOffset <= 0.0f){
        CGFloat newheight = _headerHeight - yOffset - 45;
        CGFloat newWidth = 375.0 / 184.0 * newheight;
        CGFloat x = -(newWidth - CGRectGetWidth(self.frame)) / 2.0;
        CGFloat y = yOffset;
        self.backImageView.frame = CGRectMake(x, y, newWidth, newheight);
    }
}

- (void)portraitTapGestureClick{
    if (self.tapPortraitClick) {
        self.tapPortraitClick();
    }
}

#pragma mark - setter and getters

- (UIImageView *)backImageView{
    if(_backImageView == nil){
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image =[UIImage imageNamed:@"userHome_Back"];
    }
    return _backImageView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(12,144,351,95);
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        view.layer.cornerRadius = 9;
        
        [view addSubview:self.portraitImageView];
        [view addSubview:self.nickNameButton];
        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)portraitImageView{
    if(_portraitImageView ==nil){
        UIImageView *imageView =[[UIImageView alloc]init];
        imageView.layer.cornerRadius = 34;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = UIColor.whiteColor.CGColor;
        imageView.image = [UIImage imageNamed:@"register_Default"];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitTapGestureClick)];
        [imageView addGestureRecognizer:tapGesture];
        
        _portraitImageView = imageView;
    }
    return _portraitImageView;
}

- (UIButton *)nickNameButton{
    if (_nickNameButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button setTitle:@"昵称" forState:UIControlStateNormal];
        _nickNameButton = button;
    }
    return _nickNameButton;
}

@end












@interface MySetAlertButtonView : UIView
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation MySetAlertButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:lineView];
        
        CGFloat width = CGRectGetWidth(frame) / 2.0;
        CGFloat height = CGRectGetHeight(frame) - 0.5;
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelButton.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), width,height);
        [self addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(width, CGRectGetMaxY(lineView.frame), width,height);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor colorWithRed:241/255.0 green:78/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:confirmButton];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(width, 10, 0.5, height - 20)];
        lineView1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:lineView1];
                
        _cancelButton = cancelButton;
        _confirmButton = confirmButton;
    }
    return self;
}

@end


@interface MySetNickNameAlertView()
@property (nonatomic, copy) void(^nickNameBlock)(NSString *nickname);
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation MySetNickNameAlertView

+ (void)showWithBlock:(void(^)(NSString *nickname))nickNameBlock{
    MySetNickNameAlertView *alertView = [[MySetNickNameAlertView alloc] init];
    alertView.nickNameBlock = nickNameBlock;
    [alertView show];
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.frame = UIScreen.mainScreen.bounds;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
        [self addObserverNotification];
    }
    return self;
}

//出现
- (void)show{
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    self.coverButton.alpha = 0;
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
         self.contentView.alpha = 1;
         self.coverButton.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

// 消失
- (void)dismissPickerView{
    [_textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
         self.contentView.alpha = 0;
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished){
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}

- (void)keyboardChangeAnimation:(CGFloat)maxY{
    CGFloat height = self.contentView.frame.size.height;
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, maxY - height - 20, CGRectGetWidth(self.contentView.bounds), height);
}

#pragma mark - Notification

//监测键盘的高度
- (void)addObserverNotification{
    __weak typeof(self) weakSelf = self;
    
    //键盘弹出
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        NSDictionary *info = [note userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:duration animations:^{
            [weakSelf keyboardChangeAnimation:endKeyboardRect.origin.y];
        } completion:^(BOOL finished) {}];
    }];
    
    //键盘消失
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        NSDictionary *info = [note userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            weakSelf.contentView.center = CGPointMake(CGRectGetWidth(weakSelf.bounds) / 2.0, CGRectGetHeight(weakSelf.bounds) / 2.0);
        } completion:^(BOOL finished) {}];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note){
        NSDictionary *info = [note userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:duration animations:^{
            [weakSelf keyboardChangeAnimation:endKeyboardRect.origin.y];
        } completion:^(BOOL finished) {}];
    }];
}

#pragma mark - response click

- (void)confirmButtonClick{
    [_textField resignFirstResponder];
    if (_textField.text.length) {
        if (self.nickNameBlock) {
            self.nickNameBlock(_textField.text);
        }
        [self dismissPickerView];
    }
}

#pragma mark - setter and getter

- (UIButton *)coverButton{
    if (_coverButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        button.frame = self.bounds;
        _coverButton = button;
    }
    return _coverButton;
}

- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(50, (CGRectGetHeight(self.frame) - 135) / 2.0, CGRectGetWidth(self.frame) - 50 * 2.0, 90 + 45)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 15.0;
        view.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 37, CGRectGetWidth(view.frame) - 24, 16)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"修改昵称";
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        [view addSubview:label];
        
        UIView *textBack = [[UIView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(label.frame) + 27, CGRectGetWidth(view.bounds) - 80, 38)];
        textBack.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        textBack.layer.cornerRadius = 19;
        textBack.clipsToBounds = YES;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, CGRectGetWidth(textBack.bounds) - 16, CGRectGetHeight(textBack.bounds))];
        _textField.text = UserManager.shareUser.nickName;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = @"请输入昵称";
        _textField.textAlignment = NSTextAlignmentLeft;
        [textBack addSubview:_textField];
        [view addSubview:textBack];
        
        MySetAlertButtonView *buttonView = [[MySetAlertButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textBack.frame) + 25, CGRectGetWidth(view.bounds), 45)];
        [buttonView.cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buttonView];
        
        CGFloat height = CGRectGetMaxY(buttonView.frame);
        view.frame = CGRectMake(50, (CGRectGetHeight(self.frame) - height) / 2.0, CGRectGetWidth(self.frame) - 50 * 2.0, height);
        _contentView = view;
    }
    return _contentView;
}

@end
