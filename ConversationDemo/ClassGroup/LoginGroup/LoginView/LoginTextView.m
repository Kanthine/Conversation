//
//  LoginTextView.m
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "LoginTextView.h"
#import <objc/runtime.h>

@implementation UITextField (Placeholder)

/*
 *【设置占位文字的颜色】
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 设置 runtime给系统的类【添加成员属性】,保存属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.placeholder == nil) {
        self.placeholder = @"";
    }
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor{
    //【获取类成员属性】
    return objc_getAssociatedObject(self, @"placeholderColor");
}


@end





@implementation LoginTextView

- (instancetype)initWithType:(LoginTextViewType)viewType{
    self = [super init];
    if (self){
        UIView *lineView = [[UIView alloc]init];
        lineView.tag = 10;
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self addSubview:lineView];
        [self addSubview:self.textFiled];

        if (viewType == LoginTextViewTypeAccount){
            self.textFiled.placeholder = @"请输入账号";
        }else if (viewType == LoginTextViewTypePassword){
            self.textFiled.placeholder = @"请输入密码";
        }else if (viewType == LoginTextViewTypeEmail){
            self.textFiled.placeholder = @"请输入邮箱";
        }
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self){
        UIView *lineView = [[UIView alloc]init];
        lineView.tag = 10;
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self addSubview:lineView];
        [self addSubview:self.textFiled];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self viewWithTag:10].frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 1);
    self.textFiled.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 16, CGRectGetHeight(self.bounds));
}

#pragma mark - setter and getter

- (UITextField *)textFiled{
    if (_textFiled == nil){
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.textColor = [UIColor whiteColor];
        textFiled.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textFiled.placeholder = @" ";
        textFiled.placeholderColor = UIColor.whiteColor;
        _textFiled = textFiled;
    }
    return _textFiled;
}

@end
