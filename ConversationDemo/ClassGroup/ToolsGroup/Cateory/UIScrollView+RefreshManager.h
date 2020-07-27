//
//  UIScrollView+RefreshManager.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/5/30.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (RefreshManager)
@property (assign, nonatomic) BOOL autoHiddenFooter;
@end

@interface UITableView (RefreshManager)
@property (assign, nonatomic) BOOL autoHiddenFooter;
@end
NS_ASSUME_NONNULL_END
