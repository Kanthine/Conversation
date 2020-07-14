//
//  UIBarButtonItem+LeftBarItem.h
//  MyYummy
//
//  Created by 苏沫离 on 2019/4/29.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (LeftBarItem)

+ (instancetype)leftBackItemWithTarget:(nullable id)target action:(nullable SEL)action;

+ (instancetype)leftItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;
    
@end

@interface UIBarButtonItem (RightBarItem)

+ (instancetype)rightItemWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;

+ (instancetype)rightItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;

@end


NS_ASSUME_NONNULL_END