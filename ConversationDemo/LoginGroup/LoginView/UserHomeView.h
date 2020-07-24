//
//  UserHomeView.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMNavbarView : UIView
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) UIButton *rightButton;
@end







@interface UserHomeTableHeaderView : UIView
@property (nonatomic ,strong) UIImageView *backImageView;

- (void)reloadData:(UserManager *)userModel;

/** 根据 TableView 的偏移量更新布局
 */
- (void)updateLayoutByOffset:(CGFloat)yOffset;

@end


NS_ASSUME_NONNULL_END
