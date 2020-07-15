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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    if (UserManager.shareUser.nickName) {
        ConversationViewController *vc = [[[ConversationViewController alloc]init]initWithID:UserManager.shareUser.nickName];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNav.delegate = loginNav;
        loginNav.transitionType = TransitionAnimationTypeFlip;
        loginNav.navigationBarHidden = YES;
        self.window.rootViewController = loginNav;
    }
    
    return YES;
}

@end
