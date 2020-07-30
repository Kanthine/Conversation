//
//  ConversationTableImageCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationTableImageCell.h"

@interface ConversationTableImageCell()
@property (nonatomic ,strong) UIImageView *photoView;
@end

@implementation ConversationTableImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.photoView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat portrait_center_Y = 15 + 5;
    if (self.model.direction == ConversationDirection_SEND) {
        self.portraitImageView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) - 14 - 15, portrait_center_Y);
        self.photoView.frame = CGRectMake(self.portraitImageView.frame.origin.x - 10 - (self.model.contentSize.width + 20),portrait_center_Y, self.model.contentSize.width + 20, self.model.contentSize.height + 12);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.photoView.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.photoView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.photoView.layer.mask = maskLayer;
    }else{
        self.portraitImageView.center = CGPointMake(14 + 15, portrait_center_Y);
        self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, 0, 100, 16);
        self.photoView.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, portrait_center_Y, self.model.contentSize.width + 20, self.model.contentSize.height + 12);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.photoView.bounds byRoundingCorners:UIRectCornerTopRight| UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.photoView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.photoView.layer.mask = maskLayer;
    }
    
    if (self.model.cellHeight == 0) {
        self.model.cellHeight = CGRectGetMaxY(self.photoView.frame) + 10;
    }
}

- (void)setModel:(ConversationModel *)model{
    [super setModel:model];
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:[UIImage imageNamed:@""]];
    [self setNeedsDisplay];
}

#pragma mark - setter and getters

- (UIImageView *)photoView{
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
        _photoView.backgroundColor = UIColor.whiteColor;
    }
    return _photoView;
}

@end


