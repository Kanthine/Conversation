//
//  ConversationEmojiContentView.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConversationEmojiContentViewDelegate <NSObject>

@required

/* 点击表情的事件
 * @image 选中的表情图片
 */
- (void)didSelectItem:(UIImage *)image;

@end

/* 表情内容视图
 *
 */
@interface ConversationEmojiContentView : UIView

@property (nonatomic ,weak) id <ConversationEmojiContentViewDelegate> delegate;

- (void)showContentSize:(CGSize)contentSize toolsHeight:(CGFloat)toolsHeight;

- (void)loadEmojiData:(NSMutableArray *)dataArray;

- (void)reloadRecentlyData:(NSMutableArray *)recentlyData;
@end




NS_ASSUME_NONNULL_END
