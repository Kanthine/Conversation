//
//  ConversationObjectModel.h
//
//  Created by 沫离 苏 on 2019/9/17
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConversationObjectModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *curUserImage;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *shopNo;
@property (nonatomic, strong) NSString *shopUserId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopUserImage;

- (void)parserObjectWithDictionary:(NSDictionary *)dict;

@end
