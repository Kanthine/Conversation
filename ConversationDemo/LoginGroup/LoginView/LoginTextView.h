//
//  LoginTextView.h
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LoginTextViewType) {
    LoginTextViewTypeAccount = 0,
    LoginTextViewTypePassword,
    LoginTextViewTypeEmail,
};
@interface UITextField (Placeholder)
/*
 *【设置占位文字的颜色】
 * @param placeholderColor  占位文字的颜色
 */
@property UIColor *placeholderColor;


@end



@interface LoginTextView : UIView

@property (nonatomic ,strong) UITextField *textFiled;

- (instancetype)initWithType:(LoginTextViewType)viewType;

@end
