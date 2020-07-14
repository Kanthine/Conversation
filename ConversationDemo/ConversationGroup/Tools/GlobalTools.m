//
//  GlobalTools.m
//  TakeoutUser
//
//  Created by 苏沫离 on 2019/4/24.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "GlobalTools.h"

#pragma mark - 屏幕适配

//判断是否是刘海屏
BOOL isIPhoneNotchScreen(void){
    /* iPhone8 Plus  UIEdgeInsets: {20, 0, 0, 0}
     * iPhone8       UIEdgeInsets: {20, 0, 0, 0}
     * iPhone XR     UIEdgeInsets: {44, 0, 34, 0}
     * iPhone XS     UIEdgeInsets: {44, 0, 34, 0}
     * iPhone XS Max UIEdgeInsets: {44, 0, 34, 0}
     */
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        
        CGFloat bottomSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        return bottomSpace > 0 ? YES : NO;
        
    } else {
        return NO;
    }
}

//是否是 4 寸屏幕
BOOL isSmallScreen(void){
    if (CGRectGetWidth(UIScreen.mainScreen.bounds) < 330) {
        return YES;
    }else{
        return NO;
    }
}

//获取导航栏高度
CGFloat getNavigationBarHeight(void){
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat topSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                topSpace = safeAreaInsets.top;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                topSpace = safeAreaInsets.left;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                topSpace = safeAreaInsets.right;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                topSpace = safeAreaInsets.bottom;
            }break;
            default:
                topSpace = safeAreaInsets.top;
                break;
        }
        
        if (topSpace == 0) {
            topSpace = 20.0f;
        }
        return topSpace + 44.0f;
    } else {
        return 64.0f;
    }
}

//获取tabBar高度
CGFloat getTabBarHeight(void){
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat bottomSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        return bottomSpace + 49.0;
    } else {
        return 49.0;
    }
}
CGFloat getPageSafeAreaHeight(BOOL isShowNavBar){
    
    CGFloat screenHeight = CGRectGetHeight(UIScreen.mainScreen.bounds);
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat topSpace = 0;
        CGFloat bottomSpace = 0;
        
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                topSpace = safeAreaInsets.top;
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                topSpace = safeAreaInsets.left;
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                topSpace = safeAreaInsets.right;
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                topSpace = safeAreaInsets.bottom;
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                topSpace = safeAreaInsets.top;
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        
        if (topSpace == 0) {
            topSpace = 20.0f;
        }
        
        if (isShowNavBar) {
            topSpace += 44.0f;
            return screenHeight - topSpace - bottomSpace;
        }else{
            return screenHeight - bottomSpace;
        }
    } else {
        return screenHeight - 64.0f;
    }
}


#pragma mark - 时间转换

/** 将秒数转为 mm:ss
 * @note 如果大于一小时，则转换成 hh:mm:ss
 */
NSString *transformTimeToMMSS(NSTimeInterval duration){
    int total = (int)duration;
    int seconds = total % 60;
    int minutes = (total / 60) % 60;
    int hours = total / 3600;
    if (hours > 1) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}

/** 将秒数转为 hh:mm:ss
 * @note 如果小于一小时，则转换成 00:mm:ss
 */
NSString *transformTimeToHHMMSS(NSTimeInterval duration){
    int total = (int)duration;
    int seconds = total % 60;
    int minutes = (total / 60) % 60;
    int hours = total / 3600;
    if (hours > 1) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"00:%02d:%02d", minutes, seconds];
    }
}
