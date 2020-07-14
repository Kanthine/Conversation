//
//  ConversationStatusDefine.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#ifndef ConversationStatusDefine_h
#define ConversationStatusDefine_h

/* 消息的方向
 */
typedef NS_ENUM(NSUInteger, ConversationDirection) {
    ConversationDirection_SEND = 1,//发送
    ConversationDirection_RECEIVE = 2//接收
};

/* 消息类型
 */
typedef NS_ENUM(NSUInteger, ConversationType) {
    ConversationType_TEXT = 0,//文本消息
    ConversationType_IMAGE,//图片
    ConversationType_ORDER,//订单
    ConversationType_Seats,//订座
};



#endif /* ConversationStatusDefine_h */
