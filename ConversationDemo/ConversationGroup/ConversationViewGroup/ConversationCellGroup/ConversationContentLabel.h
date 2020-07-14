//
//  ConversationContentLabel.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/24.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationContentParserTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConversationContentLabel : UILabel
<NSLayoutManagerDelegate>

@property (nonatomic, copy) void (^linkBlock)(ConversationContentLinkValueModel *linkModel);

@end

NS_ASSUME_NONNULL_END
