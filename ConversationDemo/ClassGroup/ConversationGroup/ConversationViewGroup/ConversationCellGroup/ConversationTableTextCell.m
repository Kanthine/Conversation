//
//  ConversationTableTextCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationTableTextCell.h"
#import "ConversationContentLabel.h"
#import "ConversationContentParserTool.h"

CGFloat getConversationTableTextCellHeight(ConversationModel *model){
    return 5 + 15 + 6 + model.contentSize.height + 6 + 10;;
}

@interface ConversationTableTextCell()
@property (nonatomic ,strong) UIView *messageContentView;
@property (nonatomic ,strong) ConversationContentLabel *messageLabel;
@end

@implementation ConversationTableTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.messageContentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.messageLabel.frame = CGRectMake(10, 6, self.model.contentSize.width + 2, self.model.contentSize.height + 2);
    CGFloat portrait_center_Y = 15 + 5;

    if (self.model.direction == ConversationDirection_SEND) {
        self.portraitImageView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) - 14 - 15, portrait_center_Y);
        
        CGFloat x = self.portraitImageView.frame.origin.x - 10 - (self.model.contentSize.width + 20);
        CGFloat width = self.model.contentSize.width + 20;
        self.nickNameLabel.frame = CGRectMake(x, 0, width, 16);
        self.messageContentView.frame = CGRectMake(x, portrait_center_Y, width, self.model.contentSize.height + 12);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageContentView.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.messageContentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.messageContentView.layer.mask = maskLayer;
    }else{
        self.portraitImageView.center = CGPointMake(14 + 15, portrait_center_Y);
        self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, 0, 100, 16);
        self.messageContentView.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, portrait_center_Y, self.model.contentSize.width + 20, self.model.contentSize.height + 12);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageContentView.bounds byRoundingCorners:UIRectCornerTopRight| UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.messageContentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.messageContentView.layer.mask = maskLayer;
    }
    
    if (self.model.cellHeight == 0) {
        self.model.cellHeight = CGRectGetMaxY(self.messageContentView.frame) + 10;
    }
}

- (void)setModel:(ConversationModel *)model{
    [super setModel:model];
    
    if (model.content.length > 0) {
        self.messageLabel.attributedText = model.attributedString;
    }else{
        self.messageLabel.attributedText = nil;
    }
    [self setNeedsDisplay];
}

#pragma mark - setter and getters

- (UIView *)messageContentView{
    if (_messageContentView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        [view addSubview:self.messageLabel];
        _messageContentView = view;
    }
    return _messageContentView;
}

- (ConversationContentLabel *)messageLabel{
    if (_messageLabel == nil){
        ConversationContentLabel *label = [[ConversationContentLabel alloc] initWithFrame:CGRectMake(16, 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 16 * 2.0, 20)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _messageLabel = label;
    }
    return _messageLabel;
}

@end


