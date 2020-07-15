//
//  LoginTextView.m
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "LoginTextView.h"
#import <Masonry.h>
#import <objc/runtime.h>

@implementation UITextField (Placeholder)

/*
 *【设置占位文字的颜色】
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 设置 runtime给系统的类【添加成员属性】,保存属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    //【获取类成员属性】
    return objc_getAssociatedObject(self, @"placeholderColor");
}


@end





@implementation LoginTextView

- (instancetype)initWithType:(LoginTextViewType)viewType
{
    self = [super init];
    
    if (self)
    {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        
        [self addSubview:self.textFiled];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(0);
            make.right.mas_equalTo(-16);
        }];
        if (viewType == LoginTextViewTypeAccount)
        {
            self.textFiled.placeholder = @"请输入账号";
        }
        else if (viewType == LoginTextViewTypePassword)
        {
            self.textFiled.placeholder = @"请输入密码";
        }
        else if (viewType == LoginTextViewTypeEmail)
        {
            self.textFiled.placeholder = @"请输入邮箱";
        }

        self.textFiled.placeholderColor = [UIColor whiteColor];

    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        
        [self addSubview:self.textFiled];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(0);
            make.right.mas_equalTo(-16);
        }];
        
    }
    return self;
}



#pragma mark - setter and getter

- (UITextField *)textFiled
{
    if (_textFiled == nil)
    {
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.textColor = [UIColor whiteColor];
        textFiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        
        _textFiled = textFiled;
    }
    return _textFiled;
}

@end
