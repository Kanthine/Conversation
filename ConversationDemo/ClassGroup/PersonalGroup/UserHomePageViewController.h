//
//  UserHomePageViewController.h
//  FM
//
//  Created by 苏沫离 on 2020/3/3.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 用户主页
 */
@interface UserHomePageViewController : UIViewController
@property (nonatomic ,strong) NSString *userId;
- (instancetype)initWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
