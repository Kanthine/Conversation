//
//  ConversationTableOrderCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/* 订单消息
*/
@interface ConversationTableOrderCell : ConversationTableBaseCell
@property (nonatomic ,strong) UIImageView *logoImageView;
@property (nonatomic ,strong) UILabel *unReadCountLabel;
@property (nonatomic ,strong) UILabel *itemLable;
@property (nonatomic ,strong) UILabel *messageLable;
@property (nonatomic ,strong) UILabel *dateLable;
@end

NS_ASSUME_NONNULL_END
