//
//  ConversationTableSeatsCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableSeatsCell.h"
//#import <UIImageView+WebCache.h>
#import <Masonry.h>


CGFloat const kConversationTableSeatsCellHeight = (14 + 18 + 14) + (14 + 60 + 14) + 10;

@interface ConversationTableSeatsCell()
@property (nonatomic ,strong) UIView *lineView;
@end

@implementation ConversationTableSeatsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = 5.0;
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:self.storeNameLable];
        [self.contentView addSubview:self.statusLable];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.countLable];
        [self.contentView addSubview:self.timeLable];
        [self.contentView addSubview:self.typeLable];
        
        CGFloat space = 14.0;
        [self.storeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(space);
            make.left.mas_equalTo(space);
            make.right.lessThanOrEqualTo(self.statusLable.mas_left).with.offset(-10);
        }];
        
        [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.storeNameLable.mas_centerY);
            make.right.mas_equalTo(-space);
        }];
        [self.storeNameLable setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.statusLable setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storeNameLable.mas_bottom).with.offset(space);
            make.left.mas_equalTo(space);
            make.right.mas_equalTo(-space);
            make.height.mas_equalTo(1);
        }];
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).with.offset(space);
            make.left.mas_equalTo(space);
            make.width.height.mas_equalTo(60);
        }];
        
        [self.countLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.mas_top).with.offset(-2);
            make.left.equalTo(self.logoImageView.mas_right).with.offset(8);
            make.right.mas_equalTo(-space);
        }];
        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.countLable.mas_bottom).with.offset(8);
            make.left.equalTo(self.logoImageView.mas_right).with.offset(8);
            make.right.mas_equalTo(-space);
        }];
        
        [self.typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.logoImageView.mas_bottom).with.offset(0);
            make.left.equalTo(self.logoImageView.mas_right).with.offset(8);
            make.right.mas_equalTo(-space);
        }];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect content_frame = CGRectMake(14, 0, CGRectGetWidth(self.frame) - 14 * 2.0, CGRectGetHeight(self.frame) - 10);
    self.contentView.frame = content_frame;
}

- (void)setModel:(ConversationModel *)model{
    self.storeNameLable.text = model.seatsInfo.shopName;
//    self.statusLable.text = getSeatsDescFromeBackground(model.seatsInfo.state);
    self.timeLable.text = [NSString stringWithFormat:@"时间：%@",model.seatsInfo.reserveTime];
    self.countLable.text = [NSString stringWithFormat:@"人数：%@",model.seatsInfo.personCount];
    self.typeLable.text = [NSString stringWithFormat:@"类型：%@",model.seatsInfo.seatType];
//    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.seatsInfo.shopImage]];
}

- (NSMutableAttributedString *)getPriceAttributedText:(NSString *)price{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"$" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:13],NSForegroundColorAttributeName:[UIColor colorWithRed:219/255.0 green:0/255.0 blue:8/255.0 alpha:1.0]}]];
//    [string appendAttributedString:[[NSAttributedString alloc] initWithString:getNormalPrice(price) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:219/255.0 green:0/255.0 blue:8/255.0 alpha:1.0]}]];
    return string;
}

#pragma mark - setter and getters

- (UILabel *)storeNameLable{
    if (_storeNameLable == nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 16 * 2.0, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _storeNameLable = label;
    }
    return _storeNameLable;
}

- (UILabel *)statusLable{
    if (_statusLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:252/255.0 green:181/255.0 blue:15/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentRight;
        _statusLable = label;
    }
    return _statusLable;
}

- (UILabel *)countLable{
    if (_countLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _countLable = label;
    }
    return _countLable;
}

- (UILabel *)timeLable{
    if (_timeLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _timeLable = label;
    }
    return _timeLable;
}

- (UILabel *)typeLable{
    if (_typeLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _typeLable = label;
    }
    return _typeLable;
}

- (UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.cornerRadius = 3.0;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.clipsToBounds = YES;
    }
    return _logoImageView;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    }
    return _lineView;
}
@end

