//
//  NSObject+GetTheController.m
//  Yanzhi
//
//  Created by 苏沫离 on 2018/8/16.
//  Copyright © 2018年 com.ecpss.gaoyanzhi. All rights reserved.
//

#import "NSObject+GetTheController.h"

@implementation NSObject (GetTheController)

+ (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    
    return result;
}


@end


@implementation UIView (GetTheController)

///获取view对应的控制器
- (UIViewController *_Nullable)viewTheController
{
    for (UIView *nextVC = [self superview]; nextVC; nextVC = nextVC.superview)
    {
        UIResponder* nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *_Nullable)viewTheNavController{
    UIResponder *currentNav = self.nextResponder;
    while ([currentNav isKindOfClass:UINavigationController.class] == NO)
        currentNav = currentNav.nextResponder;
    
    return [currentNav isKindOfClass:UINavigationController.class] ? (UINavigationController *)currentNav : nil;
}

@end


