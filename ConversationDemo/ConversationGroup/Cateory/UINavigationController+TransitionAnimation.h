//
//  UINavigationController+TransitionAnimation.h
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/15.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,TransitionAnimationType) {
    TransitionAnimationTypeNormal = 0,
    TransitionAnimationTypeFlip,
    TransitionAnimationTypeScale,
    TransitionAnimationTypeWind,
    TransitionAnimationTypeDrawer,
};


@interface UINavigationController (TransitionAnimation)
<UINavigationControllerDelegate>

@property (nonatomic, assign) TransitionAnimationType transitionType;

@end


NS_ASSUME_NONNULL_END
