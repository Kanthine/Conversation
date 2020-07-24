//
//  UserHomeView.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserHomeView.h"
#import "GlobalTools.h"
#import <UIImageView+WebCache.h>





@interface FMNavbarView ()
{
    CGFloat _start_Y;
}
@end

@implementation FMNavbarView

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), getNavigationBarHeight())];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _start_Y = isIPhoneNotchScreen() ? 44 : 20;
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.titleLable];
        [self addSubview:self.backButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

#pragma mark - setter and getters

- (UIButton *)backButton{
    if (_backButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.frame = CGRectMake(0, _start_Y, 60, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [button setImage:[UIImage imageNamed:@"bookDetaile_navbar_left"] forState:UIControlStateNormal];
        _backButton = button;
    }
    return _backButton;
}

- (UILabel *)titleLable{
    if (_titleLable == nil){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, _start_Y + 13, CGRectGetWidth(UIScreen.mainScreen.bounds) - 30 * 2.0, 18)];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = UIColor.whiteColor;
        _titleLable = label;
    }
    return _titleLable;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 44, _start_Y, 44, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        _rightButton = button;
    }
    return _rightButton;
}

@end





















@interface UserHomeTableHeaderView ()
{
    CGFloat _headerHeight;
}
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIImageView *portraitImageView;
@property (nonatomic ,strong) UILabel *nickNameLabel;
@property (nonatomic ,strong) UIButton *chatButton;
@end

@implementation UserHomeTableHeaderView

- (instancetype)init{

    self = [super init];
    if(self){
        [self addSubview:self.backImageView];
        [self addSubview:self.contentView];
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        self.frame = CGRectMake(0, isIPhoneNotchScreen() ? -44 : -20,width, 184 / 375.0 * width + 60);
        
        self.backImageView.frame = CGRectMake(0, 0, width, 184 / 375.0 * width);
        
        self.contentView.frame = CGRectMake(12,CGRectGetMaxY(self.backImageView.frame) - 40,width - 12 * 2.0,95);

        self.chatButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 12 - 54, 10,54, 24);
        self.portraitImageView.frame = CGRectMake(14, -30,68, 68);
        CGFloat nick_X = CGRectGetMaxX(self.portraitImageView.frame) + 12;
        CGFloat nick_width = self.frame.origin.x - 12 - nick_X;
        self.nickNameLabel.frame = CGRectMake(nick_X, 12,nick_width, 20);
        _headerHeight = CGRectGetHeight(self.frame);
    }
    return self;
}

#pragma mark - public method

- (void)reloadData:(UserManager *)userModel{
    self.nickNameLabel.text = userModel.nickName;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userModel.headPath] placeholderImage:[UIImage imageNamed:@"register_Default"]];
}

- (void)updateLayoutByOffset:(CGFloat)yOffset{
    if (yOffset <= 0.0f){
        CGFloat newheight = _headerHeight - yOffset - 60;
        CGFloat newWidth = 375.0 / 184.0 * newheight;
        CGFloat x = -(newWidth - CGRectGetWidth(self.frame)) / 2.0;
        CGFloat y = yOffset;
        self.backImageView.frame = CGRectMake(x, y, newWidth, newheight);
    }
}

#pragma mark - setter and getters

- (UIImageView *)backImageView{
    if(_backImageView == nil){
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image =[UIImage imageNamed:@"userHome_Back"];
    }
    return _backImageView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(12,144,351,95);
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        view.layer.cornerRadius = 9;
        
        [view addSubview:self.portraitImageView];
        [view addSubview:self.nickNameLabel];
        [view addSubview:self.chatButton];
        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)portraitImageView{
    if(_portraitImageView ==nil){
        UIImageView *imageView =[[UIImageView alloc]init];
        imageView.layer.cornerRadius = 34;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = UIColor.whiteColor.CGColor;
        imageView.image = [UIImage imageNamed:@"TempHead"];
        _portraitImageView = imageView;
    }
    return _portraitImageView;
}

- (UILabel *)nickNameLabel{
    if(_nickNameLabel == nil){
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = UIColor.blackColor;
        _nickNameLabel = label;
    }
    return _nickNameLabel;
}

- (UIButton *)chatButton{
    if (_chatButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        button.layer.cornerRadius = 12;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button setTitle:@"私信" forState:UIControlStateNormal];
        _chatButton = button;
    }
    return _chatButton;
}

@end
