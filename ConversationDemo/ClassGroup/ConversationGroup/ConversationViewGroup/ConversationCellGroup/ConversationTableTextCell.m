//
//  ConversationTableTextCell.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationTableTextCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "ConversationContentLabel.h"
#import "ConversationContentParserTool.h"

CGFloat getConversationTableTextCellHeight(ConversationModel *model){
    return 15 + 6 + model.contentSize.height + 6 + 10;;
}

@interface ConversationTableTextCell()
@property (nonatomic ,strong) UIView *messageContentView;
@property (nonatomic ,strong) ConversationContentLabel *messageLabel;
@end

@implementation ConversationTableTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.portraitImageView];
        [self.contentView addSubview:self.messageContentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.messageLabel.frame = CGRectMake(10, 6, self.model.contentSize.width + 2, self.model.contentSize.height + 2);
    
    if (self.model.direction == ConversationDirection_SEND) {
        self.portraitImageView.center = CGPointMake(CGRectGetWidth(self.contentView.frame) - 14 - 15, 15);
        self.messageContentView.frame = CGRectMake(self.portraitImageView.frame.origin.x - 10 - (self.model.contentSize.width + 20), self.portraitImageView.center.y, self.model.contentSize.width + 20, self.model.contentSize.height + 12);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageContentView.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerBottomRight | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.messageContentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.messageContentView.layer.mask = maskLayer;
    }else{
        self.portraitImageView.center = CGPointMake(14 + 15, 15);
        self.messageContentView.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, self.portraitImageView.center.y, self.model.contentSize.width + 20, self.model.contentSize.height + 12);
        
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

- (void)portraitTapGestureClick{
    if (self.tapPortraitClick) {
        self.tapPortraitClick();
    }
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


