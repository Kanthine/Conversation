//
//  ConversationViewController.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* 会话界面
 */
@interface ConversationViewController : UIViewController

@property (nonatomic ,assign) BOOL isGroup;

- (instancetype)initWithID:(NSString *)idString;
@end

NS_ASSUME_NONNULL_END



