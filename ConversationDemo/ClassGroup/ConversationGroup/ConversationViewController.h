//
//  ConversationViewController.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 会话界面
 * http://route.51mypc.cn/notes/
 * https://route.51mypc.cn/chat/chat.html
 * http://route.51mypc.cn/chat/chat.html
 */
@class ConversationUserModel;
@interface ConversationViewController : UIViewController

- (instancetype)initWithTargetUser:(ConversationUserModel *)target;

@end

NS_ASSUME_NONNULL_END



