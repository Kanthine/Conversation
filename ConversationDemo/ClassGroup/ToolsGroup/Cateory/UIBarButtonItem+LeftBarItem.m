//
//  UIBarButtonItem+LeftBarItem.m
//  MyYummy
//
//  Created by 苏沫离 on 2019/4/29.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "UIBarButtonItem+LeftBarItem.h"

@implementation UIBarButtonItem (LeftBarItem)
    
+ (instancetype)leftBackItemWithTarget:(nullable id)target action:(nullable SEL)action{
    return [UIBarButtonItem leftItemWithImage:[UIImage imageNamed:@"navBar_left_back_black"] target:target action:action];
}

+ (instancetype)leftItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(0, 0, 50, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return leftBarItem;
}
    
    
@end


@implementation UIBarButtonItem (RightBarItem)

+ (instancetype)rightItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.frame = CGRectMake(0, 0, 50, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return leftBarItem;
}

+ (instancetype)rightItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barItem;
}

@end
