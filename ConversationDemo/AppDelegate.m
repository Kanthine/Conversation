//
//  AppDelegate.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ConversationViewController.h"
#import "UserManager.h"
#import "LoginViewController.h"
#import "UINavigationController+TransitionAnimation.h"
#import "HttpManager.h"
#import <AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    UINavigationBar.appearance.backgroundColor = UIColor.whiteColor;
    UINavigationBar.appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColor.blackColor};
    
    if (UserManager.shareUser.nickName) {
        ConversationViewController *vc = [[ConversationViewController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNav.delegate = loginNav;
        loginNav.transitionType = TransitionAnimationTypeFlip;
        loginNav.navigationBarHidden = YES;
        self.window.rootViewController = loginNav;
    }
    

//    NSDictionary *dict = @{@"userName":@"马帅1号",
//                           @"password":@"123456",
//                           @"nickName":@"马帅1号",};
//    AFHTTPSessionManager *manager = AFHTTPSessionManager.manager;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:  @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil]; // 设置接受数据的格式
//
//    //@"Content-Type"
//    [manager POST:@"http://route.51mypc.cn/api/user/reg" parameters:dict headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSError *err;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
//        NSLog(@"responseObject ===== %@",dict);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error ----- %@",error);
//    }];

    return YES;
}

- (void)loginOrRegisterSuccess{
    ConversationViewController *vc = [[ConversationViewController alloc]init];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
}

@end
