//
//  ConversationTableOrderCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableOrderCell.h"
#import <Masonry.h>

@interface ConversationTableOrderCell()
@end

@implementation ConversationTableOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.unReadCountLabel];
        [self.contentView addSubview:self.itemLable];
        [self.contentView addSubview:self.messageLable];
        [self.contentView addSubview:self.dateLable];
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.width.height.mas_equalTo(50);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.itemLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).with.offset(12);
            make.top.equalTo(self.logoImageView.mas_top).with.offset(0);
            make.right.lessThanOrEqualTo(self.dateLable.mas_left).with.offset(10);
        }];
        
        [self.dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.equalTo(self.itemLable.mas_top).with.offset(0);
        }];
        [self.itemLable setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.dateLable setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        
        [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemLable.mas_left).with.offset(0);
            make.bottom.equalTo(self.logoImageView.mas_bottom).with.offset(0);
        }];
        

        
        [self.unReadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).with.offset(-10);
            make.top.equalTo(self.logoImageView.mas_top).with.offset(0);
            make.height.mas_equalTo(12);
        }];
    }
    
    return self;
}

- (void)setModel:(ConversationModel *)model{

}

#pragma mark - setter and getters

- (UILabel *)itemLable{
    if (_itemLable == nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 16 * 2.0, 20)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _itemLable = label;
    }
    return _itemLable;
}

- (UILabel *)messageLable{
    if (_messageLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _messageLable = label;
    }
    return _messageLable;
}

- (UILabel *)dateLable{
    if (_dateLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1.0];
        _dateLable = label;
    }
    return _dateLable;
}

- (UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_system_logo"]];
        _logoImageView.layer.cornerRadius = 25.0;
        _logoImageView.clipsToBounds = YES;
    }
    return _logoImageView;
}

- (UILabel *)unReadCountLabel{
    if (_unReadCountLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 23;
        label.hidden = YES;
        label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:10];
        label.backgroundColor = [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:1.0];
        label.layer.cornerRadius = 5.0;
        label.clipsToBounds = YES;
        _unReadCountLabel = label;
    }
    return _unReadCountLabel;
}

@end

