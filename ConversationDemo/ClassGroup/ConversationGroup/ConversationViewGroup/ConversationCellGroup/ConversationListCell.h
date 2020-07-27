//
//  ConversationListCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConversationListCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *portraitImageView;
@property (nonatomic ,strong) UILabel *nameLable;
@property (nonatomic ,strong) UILabel *contentLable;
@property (nonatomic ,strong) UILabel *timeLable;
@property (nonatomic ,strong) ConversationUserModel *userModel;


@end

NS_ASSUME_NONNULL_END
