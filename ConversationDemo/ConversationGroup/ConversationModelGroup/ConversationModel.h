//
//  ConversationModel.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConversationStatusDefine.h"
NS_ASSUME_NONNULL_BEGIN




@interface ConversationModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *sendUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *receUserId;
@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) NSString *msgId;

@property (nonatomic ,assign) BOOL isGroup;
@property (nonatomic ,assign) CGSize contentSize;
@property (nonatomic ,assign) CGFloat cellHeight;
@property (nonatomic ,assign) ConversationDirection direction;
@property (nonatomic ,assign) ConversationType type;
@property (nonatomic, strong) NSAttributedString *attributedString;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (void)parserExtraInfo;
@end

NS_ASSUME_NONNULL_END
