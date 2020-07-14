//
//  NSObject+Swizzling.h
//  Yanzhi
//
//  Created by 苏沫离 on 2018/4/28.
//  Copyright © 2018年 com.ecpss.gaoyanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector;

@end
