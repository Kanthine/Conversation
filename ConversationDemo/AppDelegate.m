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
        ViewController *vc = [[ViewController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return YES;
}

@end
