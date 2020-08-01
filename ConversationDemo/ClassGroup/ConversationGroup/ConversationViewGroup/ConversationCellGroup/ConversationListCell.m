//
//  ConversationListCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ConversationListCell.h"

@implementation ConversationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 12);
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.timeLable];
        [self.contentView addSubview:self.contentLable];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 20;
    self.portraitImageView.frame = CGRectMake(12, y, 42, 42);
    self.timeLable.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 150 - 12, y, 150, 16);
    CGFloat x = CGRectGetMaxX(self.portraitImageView.frame) + 10;
    self.nameLable.frame = CGRectMake(x, y, self.timeLable.frame.origin.x - x - 10, 16);
    self.contentLable.frame = CGRectMake(x, CGRectGetMaxY(self.nameLable.frame) + 8, CGRectGetWidth(self.nameLable.frame), 14);
}

#pragma mark - public method

- (void)setUserModel:(ConversationUserModel *)userModel{
    _userModel = userModel;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userModel.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
    self.nameLable.text = userModel.nickName;

    [userModel asyncGetLastMessage:^(ConversationModel * _Nonnull lastMessage) {
        [self setLastMesage];
    }];
}

- (void)setLastMesage{
    ConversationModel *lastMessage = _userModel.lastMessage;
    
    NSLog(@"_userModel ===== %@",_userModel);
    
    if (lastMessage) {
        if (lastMessage.type == ConversationType_IMAGE) {
            self.contentLable.text = @"图片消息";
        }else{
            self.contentLable.attributedText = lastMessage.attributedString;
        }
        self.timeLable.text = lastMessage.showTime;
    }else{
        self.timeLable.text = @"";
        self.contentLable.text = @"还没消息？快点找我唠会";
    }
}

#pragma mark - getter and setter

- (UIImageView *)portraitImageView{
    if (_portraitImageView == nil) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 42, 42)];
        _portraitImageView.layer.cornerRadius = 21;
        _portraitImageView.clipsToBounds = YES;
    }
    return _portraitImageView;
}

- (UILabel *)nameLable{
    if (_nameLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.blackColor;
        _nameLable = label;
    }
    return _nameLable;
}

- (UILabel *)timeLable{
    if (_timeLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _timeLable = label;
    }
    return _timeLable;
}

- (UILabel *)contentLable{
    if (_contentLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        label.numberOfLines = 0;
        label.text = @"还没消息？快点找我唠会";
        _contentLable = label;
    }
    return _contentLable;
}

@end
