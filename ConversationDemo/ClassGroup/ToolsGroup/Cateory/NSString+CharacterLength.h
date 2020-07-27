//
//  NSString+CharacterLength.h
//  Yanzhi
//
//  Created by 苏沫离 on 2018/9/20.
//  Copyright © 2018年 com.ecpss.gaoyanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
FOUNDATION_EXPORT CGFloat const kUserNickNameLengthShowLimit;


@interface NSString (CharacterLength)

/* 汉字占两个字符，英文占一个字符
 *
 */
- (CGFloat)statisticalCharacterLength;

/* 换行符个数
 *
 */
- (int)newlineCharacterCount;

//截取昵称
- (NSString *)cutNickNameMoreLength;
@end
