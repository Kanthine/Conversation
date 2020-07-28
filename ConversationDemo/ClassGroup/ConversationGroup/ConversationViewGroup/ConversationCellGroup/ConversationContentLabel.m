//
//  ConversationContentLabel.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/24.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationContentLabel.h"

@interface ConversationContentLabel()

{
    ConversationContentLinkValueModel *_lastValueModel;
}

/* 界面在进行文本的渲染时，有下面几个必要条件：
 * 1、要渲染展示的内容。
 * 2、将内容渲染在某个视图上。
 * 3、内容渲染在视图上的尺寸位置和形状。
 *
 * 在TextKit框架中，提供了几个类分别对应处理上述的必要条件：
 * 1、NSTextStorage 对应要渲染展示的内容。
 * 2、Label 对应要渲染的视图。
 * 3、NSTextContainer 对应渲染的尺寸位置和形状信息。
 *
 * 除了上述3个类之外，NSLayoutManager 类作为协调者来进行布局操作。
 *
 *
 * 使用TextKit进行文本的布局展示十分繁琐：
 * 1、首先需要将显示内容定义为一个 NSTextStorage 对象
 * 2、之后为其添加一个布局管理器对象 NSLayoutManager，在NSLayoutManager中需要进行NSTextContainer的定义，定义多了NSTextContainer对象则会将文本进行分页
 * 3、最后，将要展示的NSTextContainer绑定到具体的 Label 视图上。
 *
 */

//NSLayoutManager用于管理NSTextStorage其中的文字内容的排版布局
@property (nonatomic, strong) NSLayoutManager *layoutManager;

//对应渲染的尺寸位置和形状信息
@property (nonatomic, strong) NSTextContainer *textContainer;

/*  NSTextStorage保存并管理UITextView要展示的文字内容，
 *  该类是NSMutableAttributedString的子类，
 *  由于可以灵活地往文字添加或修改属性，所以非常适用于保存并修改文字属性。
 */
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, assign) BOOL isTouchMoved;
@property (nonatomic, strong, nullable) dispatch_queue_t attributedHandelQueue;


@end

@implementation ConversationContentLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.numberOfLines = 0;

         //定义Container
        self.textContainer = [[NSTextContainer alloc] init];
        self.textContainer.lineFragmentPadding = 0;
        self.textContainer.maximumNumberOfLines = self.numberOfLines;
        self.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textContainer.size = self.frame.size;
        //定义布局管理类
        self.layoutManager = [[NSLayoutManager alloc] init];
        self.layoutManager.delegate = self;
        //将container添加进布局管理类管理
        [self.layoutManager addTextContainer:self.textContainer];
        
        [self.textContainer setLayoutManager:self.layoutManager];
        
        self.attributedHandelQueue = dispatch_queue_create("com.ConversationDemo.attributedHandel", DISPATCH_QUEUE_SERIAL);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.textContainer.size = self.bounds.size;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.textContainer.size = self.bounds.size;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [self updateTextStoreWithAttributedString:mutableAttributeString];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

#pragma mark - Layout and Rendering

/* 绘制文本相关方法
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    //使用文本容器来计算所需的bounds：首先保存当前的文本容器设置
    CGSize savedTextContainerSize = self.textContainer.size;
    NSInteger savedTextContainerNumberOfLines = self.textContainer.maximumNumberOfLines;
    
    //使用新的size和行数
    self.textContainer.size = bounds.size;
    self.textContainer.maximumNumberOfLines = numberOfLines;
    
    //用新的状态来测量文本
    CGRect textBounds;
    @try {
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
        textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        
        // 为好的测量 定位 bounds 和 size
        textBounds.origin = bounds.origin;
        textBounds.size.width = ceilf(textBounds.size.width);
        textBounds.size.height = ceilf(textBounds.size.height);
    } @finally {
        //在退出之前，在任何情况下都要恢复旧的容器状态
        self.textContainer.size = savedTextContainerSize;
        self.textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
    return textBounds;
}

- (void)drawTextInRect:(CGRect)rect {
    // 不调用 super。可能希望在调试布局和呈现问题时取消注释。
    //[super drawTextInRect:rect];
    
    // 计算视图中文本的偏移量
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];
    
    //绘图
    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];//绘制字形背景
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];//绘制字形
}

//从视图的原点返回字体范围的XY偏移量
- (CGPoint)calcTextOffsetForGlyphRange:(NSRange)glyphRange {
    CGPoint textOffset = CGPointZero;
    
    CGRect textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
    CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0f;
    if (paddingHeight > 0) {
        textOffset.y = paddingHeight;
    }
    
    return textOffset;
}

#pragma mark - private method

- (ConversationContentLinkValueModel *)getLinkValueAtLocation:(CGPoint)location {
    //如果文本为空
    if (self.textStorage.string.length == 0) {
        return nil;
    }
    
    //计算出视图中文本的偏移量
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self calcTextOffsetForGlyphRange:glyphRange];
    
    // 获取触摸位置并使用文本偏移量将其转换为文本坐标
    location.x -= textOffset.x;
    location.y -= textOffset.y;
    
    NSUInteger touchedChar = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
    
    // 如果触摸在一行最后一个字符后的空格中，我们不会把它算作对文本的一次点击
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:touchedChar effectiveRange:&lineRange];
    if (CGRectContainsPoint(lineRect, location) == NO) {
        return nil;
    }
    
    __block ConversationContentLinkValueModel *valueLink = nil;
    [self.attributedText enumerateAttribute:NSConversationContentLinkAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ((touchedChar >= range.location) &&
            touchedChar < (range.location + range.length) && value){
            valueLink = (ConversationContentLinkValueModel *)value;
            * stop = YES;
        }
    }];
    return valueLink;
}

- (void)updateTextStoreWithAttributedString:(NSAttributedString *)attributedString {
    
    if (self.textStorage) {
        [self.textStorage setAttributedString:attributedString];
    } else {
        
        //定义一个Storage
        self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
        //为Storage添加一个布局管理器
        [self.textStorage addLayoutManager:self.layoutManager];
        [self.layoutManager setTextStorage:self.textStorage];
    }
}

- (void)tapPassValue:(ConversationContentLinkValueModel *)valueModel
{
    //防止重复传值
    if (_lastValueModel.linkType == valueModel.linkType &&
        [_lastValueModel.url isEqualToString:valueModel.url]) {
    }else{
        _lastValueModel = valueModel;
        if (self.linkBlock) {
            self.linkBlock(valueModel);
        }else{
            //如果没有调用 linkBlock ，则在本类实现富文本超链接
            [self responseTapClick:valueModel];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _lastValueModel = nil;
        });
    }
}

- (void)responseTapClick:(ConversationContentLinkValueModel *)valueModel
{
    if (valueModel.linkType == ConversationContentLinkTypeImage) {
        //点击查看图片
        
    }else if (valueModel.linkType == ConversationContentLinkTypeWeb){
        //查看网页
        
    }else if (valueModel.linkType == ConversationContentLinkTypePhoneNumber){
        //电话号码
        
    }else{
        NSLog(@"linkValue ====== %@",valueModel);
    }
}

#pragma mark - touch click

/* 事件传递
 * 事件从应用程序开始，按照从上到下的顺序: UIApplication -> UIWindow -> rootViewController -> ...一级一级传递，并且系统在寻找最适合处理事件的控件时，是从后往前遍历子控件的
 * 判断视图能否接受触摸事件，如果不能，返回 nil
 * 判断触摸点是否在自己身上，如果不能，返回 nil
 * 从后往前遍历子控件，重复上面的步骤，如果没有适合的子控件，返回自己
 *
 *
 * 本 label 处于视图最上层，所以当系统寻找该 label 适合处理事件时方法就返回了，下层视图就没有了处理事件的机会
 * 下述方法用来查找响应处理事件的最终视图，重写该方法，当点击的不是具有超链接属性的富文本时，将事件透传向下一层
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.x > 0 && point.y > 0) {
        if ([self getLinkValueAtLocation:point] == nil) {
            return nil;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isTouchMoved = NO;
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    ConversationContentLinkValueModel *linkValue = [self getLinkValueAtLocation:touchLocation];
    if (linkValue){
        [self tapPassValue:linkValue];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.isTouchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    // 如果拖动手指的话就不识别
    if (self.isTouchMoved) {
        return;
    }
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    ConversationContentLinkValueModel *linkValue = [self getLinkValueAtLocation:touchLocation];
    if (linkValue){
        [self tapPassValue:linkValue];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}


@end

