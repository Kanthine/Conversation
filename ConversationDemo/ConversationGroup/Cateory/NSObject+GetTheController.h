//
//  NSObject+GetTheController.h
//  Yanzhi
//
//  Created by 苏沫离 on 2018/8/16.
//  Copyright © 2018年 com.ecpss.gaoyanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (GetTheController)
/*
 * 获取当前的 ViewController
 */
+ (UIViewController *_Nullable)getCurrentViewController;

@end


@interface UIView (GetTheController)

/* 获取view对应的控制器
 */
- (UIViewController *_Nullable)viewTheController;

- (UINavigationController *_Nullable)viewTheNavController;


@end
