//
//  ConversationTableBaseCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConversationTableBaseCell : UITableViewCell
@property (nonatomic ,strong) ConversationModel *model;

+ (ConversationTableBaseCell *)tableView:(UITableView *)tableView cellForModel:(ConversationModel *)model;

@end

NS_ASSUME_NONNULL_END
