//
//  NSString+CharacterLength.m
//  Yanzhi
//
//  Created by 苏沫离 on 2018/9/20.
//  Copyright © 2018年 com.ecpss.gaoyanzhi. All rights reserved.
//

#import "NSString+CharacterLength.h"

CGFloat const kUserNickNameLengthShowLimit = 18;


@implementation NSString (CharacterLength)


- (CGFloat)statisticalCharacterLength
{
    NSString *string = [self copy];
    
    int i;
    CGFloat n = [string length] ,l = 0 ,asciiCount = 0 ,blankCount = 0;
    CGFloat stringLength = 0;
    unichar eachChar;
    for(i = 0 ; i < n ; i++){
        eachChar = [string characterAtIndex:i];//按顺序取出单个字符
        if(isblank(eachChar)){
            blankCount++;//判断为空格占1
        }else if(isascii(eachChar)){
            asciiCount++;//判断英文占1
        }else{
            l += 2;//中文占2
        }
        stringLength = l + (asciiCount + blankCount);
    }
    return stringLength;//长度，中文占2，英文等能转ascii的占1
}

- (int)newlineCharacterCount
{
    NSString *string = [self copy];
    CGFloat n = [string length];
    CGFloat count = 0;
    unichar eachChar;
    for(int i = 0 ; i < n ; i++){
        eachChar = [string characterAtIndex:i];//按顺序取出单个字符
        if (eachChar == '\n') {
            count ++;
        }
    }
    return count;
}

- (NSString *)cutNickNameMoreLength
{
    NSString *nickName = [self copy];
    CGFloat length = [nickName statisticalCharacterLength];
    BOOL isCut = NO;
    while (length > kUserNickNameLengthShowLimit) {
        nickName = [nickName substringToIndex:nickName.length - 1];
        length = [nickName statisticalCharacterLength];
        isCut = YES;
    }
    if (isCut) {
        nickName = [NSString stringWithFormat:@"%@...",nickName];
    }
    return nickName;
}

@end
