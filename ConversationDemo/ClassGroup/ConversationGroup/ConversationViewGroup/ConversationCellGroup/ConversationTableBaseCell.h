//
//  ConversationTableBaseCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationModel.h"
NS_ASSUME_NONNULL_BEGIN

#define Cell_Text_Identifer @"ConversationTableTextCell"
#define Cell_Image_Identifer @"ConversationTableImageCell"


@interface ConversationTableBaseCell : UITableViewCell
@property (nonatomic ,strong) ConversationModel *model;
@property (nonatomic ,strong) UILabel *nickNameLabel;
@property (nonatomic ,strong) UIImageView *portraitImageView;
@property (nonatomic ,copy) void(^tapPortraitClick)(void);

+ (ConversationTableBaseCell *)tableView:(UITableView *)tableView cellAtIndexPath:(NSIndexPath *)indexPath cellForModel:(ConversationModel *)model;

+ (void)regisCellForTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
