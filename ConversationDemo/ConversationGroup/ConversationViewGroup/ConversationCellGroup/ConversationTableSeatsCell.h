//
//  ConversationTableSeatsCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT CGFloat const kConversationTableSeatsCellHeight;

/* 订座消息
*/
@interface ConversationTableSeatsCell : ConversationTableBaseCell
@property (nonatomic ,strong) UILabel *storeNameLable;
@property (nonatomic ,strong) UILabel *statusLable;
@property (nonatomic ,strong) UILabel *countLable;
@property (nonatomic ,strong) UILabel *typeLable;
@property (nonatomic ,strong) UILabel *timeLable;
@property (nonatomic ,strong) UIImageView *logoImageView;
@end



NS_ASSUME_NONNULL_END
