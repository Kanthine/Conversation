//
//  MBProgressHUD+CustomView.h
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CustomView)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

/*
 * 显示错误信息
 */
+ (void)showError:(NSString *)error;

@end
