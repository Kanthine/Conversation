//
//  ConversationTableBaseCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableBaseCell.h"

@implementation ConversationTableBaseCell

- (void)setModel:(ConversationModel *)model{
    _model = model;
}

+ (ConversationTableBaseCell *)tableView:(UITableView *)tableView cellForModel:(ConversationModel *)model{
    
    return nil;
}

@end




