//
//  GlobalTools.h
//  TakeoutUser
//
//  Created by 苏沫离 on 2019/4/24.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 屏幕适配

FOUNDATION_EXPORT BOOL isIPhoneNotchScreen(void);//是否是刘海屏
FOUNDATION_EXPORT BOOL isSmallScreen(void);//是否是4寸屏
FOUNDATION_EXPORT CGFloat getNavigationBarHeight(void);
FOUNDATION_EXPORT CGFloat getTabBarHeight(void);
FOUNDATION_EXPORT CGFloat getPageSafeAreaHeight(BOOL isShowNavBar);

#pragma mark - 时间转换

/** 将秒数转为 mm:ss
 * @note 如果大于一小时，则转换成 hh:mm:ss
 */
FOUNDATION_EXPORT NSString *transformTimeToMMSS(NSTimeInterval duration);

/** 将秒数转为 hh:mm:ss
 * @note 如果小于一小时，则转换成 00:mm:ss
 */
FOUNDATION_EXPORT NSString *transformTimeToHHMMSS(NSTimeInterval duration);




#pragma mark - 正则验证

// 新版手机号
FOUNDATION_EXPORT BOOL isMobileNumber(NSString *mobileNum);

/** 验证银行卡号
 */
FOUNDATION_EXPORT BOOL isBankCard(NSString *cardNumber);

/** 验证邮箱
 */
FOUNDATION_EXPORT BOOL isEmail(NSString *email);

/** 验证密码是否为6-12位，由数字与字母组成
 */
FOUNDATION_EXPORT BOOL judgePassWordLegal(NSString *password);

/** 验证身份证号
 */
FOUNDATION_EXPORT BOOL isIdentityCard(NSString *IDCardNumber);

/** 验证是否是有效数组
 * 非空 数组 count 大于0
 */
FOUNDATION_EXPORT BOOL isValidArray(id object);

/** 验证是否是有效字典
 */
FOUNDATION_EXPORT BOOL isValidDictionary(id object);

#pragma mark - 其它

FOUNDATION_EXPORT UIColor *colorByValue(NSInteger value,int alpha);
