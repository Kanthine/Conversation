//
//  UserHomeCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"BookTableCell"

#import "UserHomeCell.h"



@interface UserHomeTableBookSectionHeaderView ()

@end

@implementation UserHomeTableBookSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.titleLable];
        
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UITableViewHeaderFooterViewBackground")]) {
                obj.backgroundColor = UIColor.clearColor;
            }
        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(12, 12, CGRectGetWidth(self.frame) - 12 * 2.0, CGRectGetHeight(self.frame) - 12);
    self.titleLable.frame = CGRectMake(12, 0, 300, CGRectGetHeight(self.contentView.frame));
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UITableViewHeaderFooterViewBackground")]) {
            obj.backgroundColor = UIColor.clearColor;
        }
    }];
}

#pragma mark - setter and getters

- (UILabel *)titleLable{
    if (_titleLable == nil){
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColor.clearColor;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.blackColor;
        label.text = @"书架";
        _titleLable = label;
    }
    return _titleLable;
}

@end





@implementation BookTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 60, 60)];
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:_coverImageView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColor.blackColor;
        [self.contentView addSubview:_titleLabel];
        
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:11];
        _describeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.contentView addSubview:_describeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(12, 0, CGRectGetWidth(self.frame) - 12 * 2.0, CGRectGetHeight(self.frame));

    
    CGFloat contentView_width = CGRectGetWidth(self.contentView.frame);
    self.coverImageView.frame = CGRectMake(12, 18, 60, 60);
    
    CGFloat start_x = CGRectGetMaxX(self.coverImageView.frame) + 12.0;
    _titleLabel.frame = CGRectMake(start_x, 22, contentView_width - start_x - 40, 16);
    _describeLabel.frame = CGRectMake(start_x, CGRectGetMaxY(_titleLabel.frame) + 8, contentView_width - start_x - 40, 12);
}

- (void)setBookName:(NSString *)bookName{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591872709995&di=4e3a6880183a53aa598d46353a8d3a1d&imgtype=0&src=http%3A%2F%2Fpic.baike.soso.com%2Fp%2F20131122%2F20131122124912-1917471225.jpg"]];
    self.titleLabel.text = bookName;
    self.describeLabel.text = @"见到吾皇，为何不跪";
}

@end


