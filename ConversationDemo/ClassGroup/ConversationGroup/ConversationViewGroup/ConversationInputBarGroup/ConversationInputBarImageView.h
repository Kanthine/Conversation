//
//  ConversationInputBarImageView.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationInputBarImageView : UIView
@property (nonatomic ,strong) NSString *imageURL;
@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,strong) UIButton *deleteButton;

- (instancetype)initWithImage:(UIImage *)image imageURL:(NSString *)imageURL;

+ (instancetype)initializeWithImage:(UIImage *)image imageURL:(NSString *)imageURL;

@end

NS_ASSUME_NONNULL_END
