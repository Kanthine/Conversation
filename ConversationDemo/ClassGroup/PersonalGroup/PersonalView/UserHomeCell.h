//
//  UserHomeCell.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/24.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 书架
 */

@interface UserHomeTableBookSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong) UILabel *titleLable;

@end


@interface BookTableCell : UITableViewCell
@property (nonatomic ,strong) NSString *bookName;
@property (nonatomic ,strong) UIImageView *coverImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *describeLabel;
@end


NS_ASSUME_NONNULL_END
