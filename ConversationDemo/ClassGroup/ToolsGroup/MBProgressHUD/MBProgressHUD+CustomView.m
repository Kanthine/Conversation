//
//  MBProgressHUD+CustomView.m
//  objective_c_language
//
//  Created by 苏沫离 on 2018/5/31.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "MBProgressHUD+CustomView.h"

@implementation MBProgressHUD (CustomView)

/**
 *  =======显示信息
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.userInteractionEnabled= NO;
    
    hud.customView = [[UIImageView alloc] initWithImage:[self errorImage]];// 设置图片
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];//背景颜色

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:152];
}


+ (void)showError:(NSString *)error
{


}


+ (UIImage *)errorImage
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ProgressHUD" ofType:@"bundle"];
    NSBundle *hudBundel = [NSBundle bundleWithPath:filePath];
    NSString *error = [hudBundel pathForResource:@"error" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:error];
    return image;
}

@end
