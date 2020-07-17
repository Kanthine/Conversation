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
    
    UIView *view = [[UITextField alloc]initWithFrame:CGRectMake(10, 90, 100, 40)];
    view.backgroundColor = UIColor.redColor;
    [self.view addSubview:view];

}

@end
