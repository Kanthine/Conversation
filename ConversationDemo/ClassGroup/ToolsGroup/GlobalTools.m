//
//  GlobalTools.m
//  TakeoutUser
//
//  Created by 苏沫离 on 2019/4/24.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "GlobalTools.h"

#pragma mark - 屏幕适配

//判断是否是刘海屏
BOOL isIPhoneNotchScreen(void){
    /* iPhone8 Plus  UIEdgeInsets: {20, 0, 0, 0}
     * iPhone8       UIEdgeInsets: {20, 0, 0, 0}
     * iPhone XR     UIEdgeInsets: {44, 0, 34, 0}
     * iPhone XS     UIEdgeInsets: {44, 0, 34, 0}
     * iPhone XS Max UIEdgeInsets: {44, 0, 34, 0}
     */
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        
        CGFloat bottomSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        return bottomSpace > 0 ? YES : NO;
        
    } else {
        return NO;
    }
}

//是否是 4 寸屏幕
BOOL isSmallScreen(void){
    if (CGRectGetWidth(UIScreen.mainScreen.bounds) < 330) {
        return YES;
    }else{
        return NO;
    }
}

//获取导航栏高度
CGFloat getNavigationBarHeight(void){
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat topSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                topSpace = safeAreaInsets.top;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                topSpace = safeAreaInsets.left;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                topSpace = safeAreaInsets.right;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                topSpace = safeAreaInsets.bottom;
            }break;
            default:
                topSpace = safeAreaInsets.top;
                break;
        }
        
        if (topSpace == 0) {
            topSpace = 20.0f;
        }
        return topSpace + 44.0f;
    } else {
        return 64.0f;
    }
}

//获取tabBar高度
CGFloat getTabBarHeight(void){
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat bottomSpace = 0;
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        return bottomSpace + 49.0;
    } else {
        return 49.0;
    }
}
CGFloat getPageSafeAreaHeight(BOOL isShowNavBar){
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets;
        CGFloat topSpace = 0;
        CGFloat bottomSpace = 0;
        
        switch (UIApplication.sharedApplication.statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                topSpace = safeAreaInsets.top;
                bottomSpace = safeAreaInsets.bottom;
            }break;
            case UIInterfaceOrientationLandscapeLeft:{
                topSpace = safeAreaInsets.left;
                bottomSpace = safeAreaInsets.right;
            }break;
            case UIInterfaceOrientationLandscapeRight:{
                topSpace = safeAreaInsets.right;
                bottomSpace = safeAreaInsets.left;
            } break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                topSpace = safeAreaInsets.bottom;
                bottomSpace = safeAreaInsets.top;
            }break;
            default:
                topSpace = safeAreaInsets.top;
                bottomSpace = safeAreaInsets.bottom;
                break;
        }
        
        if (topSpace == 0) {
            topSpace = 20.0f;
        }
        
        if (isShowNavBar) {
            topSpace += 44.0f;
            return CGRectGetHeight(UIScreen.mainScreen.bounds) - topSpace - bottomSpace;
        }else{
            return CGRectGetHeight(UIScreen.mainScreen.bounds) - bottomSpace;
        }
    } else {
        return CGRectGetHeight(UIScreen.mainScreen.bounds) - 64.0f;
    }
}


#pragma mark - 时间转换

/** 将秒数转为 mm:ss
 * @note 如果大于一小时，则转换成 hh:mm:ss
 */
NSString *transformTimeToMMSS(NSTimeInterval duration){
    int total = (int)duration;
    int seconds = total % 60;
    int minutes = (total / 60) % 60;
    int hours = total / 3600;
    if (hours > 1) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}

/** 将秒数转为 hh:mm:ss
 * @note 如果小于一小时，则转换成 00:mm:ss
 */
NSString *transformTimeToHHMMSS(NSTimeInterval duration){
    int total = (int)duration;
    int seconds = total % 60;
    int minutes = (total / 60) % 60;
    int hours = total / 3600;
    if (hours > 1) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"00:%02d:%02d", minutes, seconds];
    }
}



#pragma mark - 正则验证

// 新版手机号
BOOL isMobileNumber(NSString *mobileNum){
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

/** 验证银行卡号
 */
BOOL isBankCard(NSString *cardNumber){
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

/** 验证邮箱
 */
BOOL isEmail(NSString *email){
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 验证密码是否为6-12位，由数字与字母组成
 */
BOOL judgePassWordLegal(NSString *password){
    BOOL result = false;
    if ([password length] <= 12  && [password length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}

/** 验证身份证号
 */
BOOL isIdentityCard(NSString *IDCardNumber){
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

/** 验证是否是有效数组
 * 非空 数组 count 大于0
 */
BOOL isValidArray(id object){
    if (object == nil){
        return NO;
    }
    if ([object isKindOfClass:[NSArray class]] == NO){
        return NO;
    }
    NSArray *array = (NSArray *)object;
    if (array.count == 0){
        return NO;
    }else{
        return YES;
    }
}

/** 验证是否是有效字典
 */
BOOL isValidDictionary(id object){
    if (object == nil){
        return NO;
    }
    if ([object isKindOfClass:[NSDictionary class]] == NO){
        return NO;
    }
    return YES;
}



#pragma mark - 其它

UIColor *colorByValue(NSInteger value,int alpha){
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha];
}
