//
//  ViewController.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"
#import "ConversationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入你的昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"text ==== %@",textField.text);
        UserManager.shareUser.nickName = textField.text;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alertController.textFields.firstObject.text.length > 0) {
            UserManager.shareUser.nickName = alertController.textFields.firstObject.text;
            
            ConversationViewController *vc = [[ConversationViewController alloc]initWithID:UserManager.shareUser.nickName];
            UIApplication.sharedApplication.delegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:agreeAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
