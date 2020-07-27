//
//  ConversationTableBaseCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableBaseCell.h"

#import "ConversationTableTextCell.h"
#import "ConversationTableImageCell.h"

@interface ConversationTableBaseCell ()

@end

@implementation ConversationTableBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setModel:(ConversationModel *)model{
    _model = model;
    if (model.direction == ConversationDirection_SEND) {
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:UserManager.shareUser.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
    }else{
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.fromHeaderPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
    }
}

- (void)portraitTapGestureClick{
    if (self.tapPortraitClick) {
        self.tapPortraitClick();
    }
}

#pragma mark - public method

+ (ConversationTableBaseCell *)tableView:(UITableView *)tableView cellAtIndexPath:(NSIndexPath *)indexPath cellForModel:(ConversationModel *)model{
    if (model.type == ConversationType_TEXT) {
        ConversationTableTextCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Text_Identifer forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else if (model.type == ConversationType_IMAGE){
        ConversationTableImageCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Image_Identifer forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return nil;
}

+ (void)regisCellForTableView:(UITableView *)tableView{
    [tableView registerClass:ConversationTableTextCell.class forCellReuseIdentifier:Cell_Text_Identifer];
    [tableView registerClass:ConversationTableImageCell.class forCellReuseIdentifier:Cell_Image_Identifer];
}

#pragma mark - setter and getters

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _portraitImageView.layer.cornerRadius = 15.0;
        _portraitImageView.clipsToBounds = YES;
        _portraitImageView.backgroundColor = UIColor.clearColor;
        _portraitImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitTapGestureClick)];
        [_portraitImageView addGestureRecognizer:tapGesture];
    }
    return _portraitImageView;
}

@end



