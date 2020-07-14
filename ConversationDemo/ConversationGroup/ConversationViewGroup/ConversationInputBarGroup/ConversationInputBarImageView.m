//
//  ConversationInputBarImageView.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/18.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationInputBarImageView.h"
#import <Masonry.h>

@interface ConversationInputBarImageView ()
@property (nonatomic ,strong) UIImageView *imageView;
@end


@implementation ConversationInputBarImageView

+ (instancetype)initializeWithImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    return [[ConversationInputBarImageView alloc] initWithImage:image imageURL:imageURL];
}

- (instancetype)initWithImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(24, 20, 72, 72);
        self.image = image;
        self.imageURL = imageURL;
        [self addSubview:self.imageView];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.frame) - (20 + 16), -10, 20 + 16 + 10, 20 + 16 + 10);
    self.imageView.frame = self.bounds;
}

#pragma mark - setter and getter

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 4;
        _imageView.clipsToBounds = YES;
        _imageView.image = self.image;
    }
    return _imageView;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"conversation_input_image_delete"] forState:UIControlStateNormal];
        _deleteButton.adjustsImageWhenHighlighted = NO;
        _deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 10);
        
    }
    return _deleteButton;
}

@end
