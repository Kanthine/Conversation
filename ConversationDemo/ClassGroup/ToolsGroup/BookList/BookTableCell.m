//
//  BookTableCell.m
//  YLRead
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "BookTableCell.h"

@implementation BookTableSectionHeaderView

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


CGFloat const kBookTableCellHeight = 105;
@interface BookTableCell ()
@property (nonatomic ,strong) UIImageView *coverImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *endLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@end

@implementation BookTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.endLabel];
        [self.contentView addSubview:self.describeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(12, 0, CGRectGetWidth(self.frame) - 12 * 2.0, CGRectGetHeight(self.frame));
    
    CGFloat contentView_width = CGRectGetWidth(self.contentView.frame);
    self.coverImageView.frame = CGRectMake(12, 18, 60, 80);
    
    CGFloat start_x = CGRectGetMaxX(self.coverImageView.frame) + 12.0;
    _titleLabel.frame = CGRectMake(start_x, 22, contentView_width - start_x - 40, 16);
    _endLabel.frame = CGRectMake(start_x,  CGRectGetMaxY(_titleLabel.frame) + 8, contentView_width - start_x - 40, 16);
    _describeLabel.frame = CGRectMake(start_x, CGRectGetMaxY(_endLabel.frame) + 8, contentView_width - start_x - 40, 30);
}

- (void)setBook:(BookModel *)book{
    _book = book;
    self.coverImageView.image = book.coverImage;
    self.titleLabel.text = book.bookName;
    self.endLabel.text = book.isEnd ? @"完结" : @"连载";
    self.describeLabel.text = book.intro;
}

#pragma mark - setter and getter

- (UIImageView *)coverImageView{
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 60, 80)];
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

- (UILabel *)endLabel{
    if (_endLabel == nil) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = [UIFont systemFontOfSize:12];
        _endLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    }
    return _endLabel;
}

- (UILabel *)describeLabel{
    if (_describeLabel == nil) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:11];
        _describeLabel.numberOfLines = 2;
        _describeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
    return _describeLabel;
}

@end


