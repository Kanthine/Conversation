//
//  ConversationContentParserTool.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/19.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import "ConversationContentParserTool.h"
#import "NSString+CharacterLength.h"

//检索图片的正则表达式
NSString * const kConversationImageLinkRegula = @"((?<=\\＜comImg:).*?(?=\\＞)|(?<=\\＜img:).*?(?=\\＞))";
//检索网页的正则表达式
NSString * const kConversationWebLinkRegula = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
//检索电话号码的正则表达式
NSString * const kConversationPhoneNumberRegula = @"(\\d{3,4}[- ]?\\d{7,8})";


//动态内容添加的链接键（使用系统的 NSLinkAttributeName ，还需要更改默认的文字样式，太过麻烦）
NSAttributedStringKey const NSConversationContentLinkAttributeName = @"com.ConversationDemo.ConversationContentLinkAttribute";

NSAttributedStringKey const NSConversationEmojiAttributeName = @"com.ConversationDemo.ConversationEmojiAttribute";

CGFloat const kConversationTextLineSapce = 4.0;


/** 2020-08-01 10:24:49
 */
NSString *transformChatTime(NSString *theTime){
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSDate *theDate = [formatter dateFromString:theTime];
    NSDate *currentDate = NSDate.date;
    NSString *currentTime = [formatter stringFromDate:currentDate];
    NSTimeInterval duration = [currentDate timeIntervalSinceDate:theDate];///时间间隔
    
    BOOL isToday = [[theTime componentsSeparatedByString:@" "].firstObject isEqualToString:[currentTime componentsSeparatedByString:@" "].firstObject];

    if (isToday) {
        if (duration <= 60) {  //// 1分钟以内的
            return @"刚刚";
        }else if(duration <= 60 * 60 ){ ///  一个小时以内的
            int mins = duration / 60;
            return [NSString stringWithFormat:@"%d分钟前",mins];
        }
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:currentDate];
    }else{
        [formatter setDateFormat:@"YYYY/MM/dd"];
        return [formatter stringFromDate:currentDate];
    }
}


@interface ConversationContentLinkValueModel ()
@property (nonatomic ,readwrite ,assign) ConversationContentLinkType linkType;
@property (nonatomic ,readwrite ,strong) NSString *url;
@property (nonatomic ,readwrite ,strong) NSDictionary *otherInfo;
@end

@implementation ConversationContentLinkValueModel

- (NSString *)description{
    return [NSString stringWithFormat:@"address:%p \n linkType：%ld \n  url: %@",self,self.linkType, self.url];
}

+ (instancetype)initializeWithLinkType:(ConversationContentLinkType)linkType url:(NSString *)url{
    return [self initializeWithLinkType:linkType url:url otherInfo:nil];
}

+ (instancetype)initializeWithLinkType:(ConversationContentLinkType)linkType url:(NSString *)url otherInfo:(NSDictionary *)otherInfo{
    ConversationContentLinkValueModel *model = [[ConversationContentLinkValueModel alloc] init];
    model.linkType = linkType;
    model.url = url;
    if (otherInfo) {
        model.otherInfo = otherInfo;
    }
    return model;
}
@end


@implementation ConversationContentParserTool

+ (NSMutableAttributedString *)parserContentWithText:(NSString *)text showImage:(BOOL)isShow font:(UIFont *)font color:(UIColor *)color{
    return [self parserContentWithText:text showImage:isShow font:font color:color isInput:NO];
}

+ (NSMutableAttributedString *)parserContentWithText:(NSString *)text showImage:(BOOL)isShow font:(UIFont *)font color:(UIColor *)color isInput:(BOOL)isInput{
    NSString *string = [text copy];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:kConversationTextLineSapce];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle}];
    
    //检索 图片、@某人、emoji 表情、网页、电话号码
    NSString *regula = [NSString stringWithFormat:@"(%@|%@|%@|%@)",
                        kConversationImageLinkRegula,
                        kConversationWebLinkRegula,
                        kConversationPhoneNumberRegula,
                        kConversationEmojiRegula];
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regula options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *matches = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:obj.range];
        NSString *imageFormat = [NSString stringWithFormat:@"＜comImg:%@＞",matchString];//图片格式
        NSString *imageFormat1 = [NSString stringWithFormat:@"＜img:%@＞",matchString];//图片格式1
        NSString *emojiFormat = [NSString stringWithFormat:@"[%@]",matchString];;//emoji格式
        
        if ([string containsString:imageFormat] || [string containsString:imageFormat1]) {
            if ([string containsString:imageFormat1]) {
                imageFormat = imageFormat1;
            }

            //文字中插入的图片
            NSRange subAllRange = [attributedString.string rangeOfString:imageFormat];//在修改后的文本中查找替代的位置
            if (isShow) {
                [attributedString replaceCharactersInRange:subAllRange withAttributedString:[ConversationContentParserTool transformImageFromeTextWithURL:matchString gap:6.0]];//转为图片
            }else{
                
                [attributedString replaceCharactersInRange:subAllRange withAttributedString:[ConversationContentParserTool getTextImageWithLink:matchString font:font allString:imageFormat isInput:isInput]];//转为图片链接
            }
        }else if ([string containsString:emojiFormat]){
            //emoji表情
            NSAttributedString *emojiString = [ConversationContentParserTool getEmojiWithName:emojiFormat font:font];
            NSRange subAllRange = [attributedString.string rangeOfString:emojiFormat];
            
            if (emojiString) {
                [attributedString replaceCharactersInRange:subAllRange withAttributedString:emojiString];
            }else{
                NSLog(@"subAllRange ======= %@",[NSValue valueWithRange:subAllRange]);
                NSLog(@"emojiString ======= %@",emojiString);
            }
            
        }else if ([matchString hasPrefix:@"http"]){
            //网页链接
            NSRange subAllRange = [attributedString.string rangeOfString:matchString];
            NSAttributedString *urlString = [ConversationContentParserTool getWebLinkWithURL:matchString font:font];
            [attributedString replaceCharactersInRange:subAllRange withAttributedString:urlString];
        }else if ([matchString hasPrefix:@"1"] && matchString.length == 11){
            //手机号
            NSRange subAllRange = [attributedString.string rangeOfString:matchString];
            ConversationContentLinkValueModel *value = [ConversationContentLinkValueModel initializeWithLinkType:ConversationContentLinkTypePhoneNumber url:matchString];
            [attributedString setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:kDynamicHighlightedLinkColor,NSConversationContentLinkAttributeName:value} range:subAllRange];
        }else{
            NSLog(@"matchString === %@",matchString);
        }
    }];
    

    
    return attributedString;
}

#pragma mark - 创建 超链接 文本

/* 创建网页链接提示
 */
+ (NSAttributedString *)getWebLinkWithURL:(NSString *)url font:(UIFont *)font
{
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, -3, 14, 14);//设置frame
    attchment.image = [UIImage imageNamed:@"urlLianJIe"];//设置图片
    
    NSAttributedString *imgaeString = [NSAttributedString attributedStringWithAttachment:attchment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:imgaeString];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"网页链接"]];
    
    [attributedString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:kDynamicHighlightedLinkColor,NSConversationContentLinkAttributeName:[ConversationContentLinkValueModel initializeWithLinkType:ConversationContentLinkTypeWeb url:url]} range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

/* 创建一个带有图片链接的富文本
 *
 * link ：解析得到的图片链接
 */
+ (NSMutableAttributedString *)getTextImageWithLink:(NSString *)link font:(UIFont *)font allString:(NSString *)string isInput:(BOOL)isInput
{
    NSString *tipString = @"查看图片";
    UIColor *backgroundColor = isInput ? UIColor.clearColor : [UIColor colorWithRed:237/255.0 green:240/255.0 blue:244/255.0 alpha:1];
    
    CGFloat space = isInput ? 2.0 : 8.0;
    CGFloat imageWidth = 14.0f;
    UIImage *image = [UIImage imageNamed:@"dynamicDetaile_text_image"];
    UIColor *textColor = kDynamicHighlightedLinkColor;
    CGSize textSize = [tipString boundingRectWithSize:CGSizeMake(100, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    CGSize drawSize = CGSizeMake(space + imageWidth + space + textSize.width + space, 20);
    CGRect drawRect = CGRectMake(0, 0, drawSize.width, drawSize.height);
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(drawSize, NO, 0);
    
    //设置背景色与圆角
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);//设置颜色
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:drawSize.height/2.0].CGPath);
    CGContextClip(context);
    CGContextFillRect(context,drawRect);//绘制
    
    //绘制图片
    [image drawInRect:CGRectMake(space, 3, imageWidth, imageWidth)];
    //添加文字
    [tipString drawAtPoint:CGPointMake(space + imageWidth + space, (drawSize.height - textSize.height) / 2.0) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    
    //初始化NSTextAttachment对象
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, -4, drawSize.width, drawSize.height);//设置frame
    attchment.image = newImage;//设置图片
    
    //创建带有图片的富文本
    NSAttributedString *imgaeString = [NSAttributedString attributedStringWithAttachment:attchment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:imgaeString];
    [attributedString addAttribute:NSConversationContentLinkAttributeName value:[ConversationContentLinkValueModel initializeWithLinkType:ConversationContentLinkTypeImage url:link otherInfo:@{@"rawData":string}] range:NSMakeRange(0, imgaeString.length)];
    
    return attributedString;
}


/* 创建一个带有图片的富文本
 * 图片最大显示尺寸：宽290，高184
 * 图片需要切圆角 4.0f
 * url ：解析得到的图片地址
 */
+ (NSAttributedString *)transformImageFromeTextWithURL:(NSString *)url gap:(float)gap
{
    /**************** 根据资源地址获取图片 **************/
    if ([url containsString:@"http"] == NO) {
        NSLog(@"url ==error== %@",url);
        NSAttributedString *imgaeString = [[NSAttributedString alloc] initWithString:@""];
        return imgaeString;
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data == nil) {
        NSLog(@"url ==data== %@",url);
        NSAttributedString *imgaeString = [[NSAttributedString alloc] initWithString:@""];
        return imgaeString;
    }
    UIImage *image = [UIImage imageWithData:data];
    image = [self imageByCropToRect:image];
    if (image == nil) {
        NSLog(@"url ==image== %@",url);
        NSAttributedString *imgaeString = [[NSAttributedString alloc] initWithString:@""];
        return imgaeString;
    }
    
    /**************** 计算图片宽高 **************/
    CGFloat standardRatio = 290.0 / 184.0;//标准宽高比：1.576
    CGSize standardSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetWidth(UIScreen.mainScreen.bounds) / standardRatio);//标准图片尺寸
    CGFloat imageRatio = image.size.width * 1.0f / image.size.height * 1.0f;
    CGSize imageShowSize = image.size;//屏幕上展示的图片尺寸
    if (imageRatio > standardRatio ) {
        //图片太宽了：宽缩小、求高
        if (image.size.width > standardSize.width) {
            CGFloat height = standardSize.width / imageRatio;
            imageShowSize = CGSizeMake(standardSize.width, height);
        }
    }else{
        //图片太高了：高缩小、求宽
        if (image.size.height > standardSize.height) {
            CGFloat width = standardSize.height * imageRatio;
            imageShowSize = CGSizeMake(width, standardSize.height);
        }
    }
    
    /**************** 裁圆角、图片上下留白 **************/
    CGFloat cornerRadius = 6.0f;//裁切圆角值
    CGSize imageGapSize = CGSizeMake(imageShowSize.width, gap + imageShowSize.height + gap);//上下留白后的展示尺寸
    CGRect contextBounds = CGRectMake(0, 0, imageGapSize.width,imageGapSize.height);//画布 bounds
    CGRect imageRect = CGRectMake(0, gap, imageShowSize.width,imageShowSize.height);//画布上图片的 frame
    UIGraphicsBeginImageContextWithOptions(imageGapSize, NO, 0);//画布的尺寸：留白尺寸
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColor.clearColor.CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:cornerRadius].CGPath);
    CGContextClip(context);
    CGContextFillRect(context,contextBounds);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    /**************** 图片转为富文本 **************/
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = contextBounds;
    attchment.image = image;//设置图片
    NSMutableAttributedString *imgaeString = [NSMutableAttributedString attributedStringWithAttachment:attchment];
    [imgaeString addAttribute:NSConversationContentLinkAttributeName value:[ConversationContentLinkValueModel initializeWithLinkType:ConversationContentLinkTypeImage url:url] range:NSMakeRange(0, imgaeString.length)];
    
    if (gap == 0) {
        return [[NSMutableAttributedString alloc] initWithAttributedString:imgaeString];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attributedString appendAttributedString:imgaeString];
    return attributedString;
}

//图片太宽、太高的处理
+ (UIImage *)imageByCropToRect:(UIImage *)image{
    CGSize imageSize = image.size;
    CGFloat imageRatio = image.size.width * 1.0f / image.size.height * 1.0f;
    CGFloat standardRatio = 290.0 / 184.0;//标准宽高比：1.576
    if (imageRatio < 0.5) {
        CGFloat maxHeight = imageSize.width / standardRatio;
        //图片高度太大，宽度铺满，上下裁剪
        CGRect rect = CGRectMake(0, (imageSize.height - maxHeight) / 2.0, imageSize.width, maxHeight);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        return newImage;
    }else if (imageRatio > 2.0){
        CGFloat maxWidth = imageSize.height * standardRatio;
        CGRect rect = CGRectMake((imageSize.width - maxWidth) / 2.0, 0, maxWidth, imageSize.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        return newImage;
    }else{
        return image;
    }
}

/* 过滤字符串中的图片
 */
+ (NSMutableString *)filterOutImageLink:(NSString *)text{
    NSMutableString *updateString = [NSMutableString stringWithString:text];
    
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:kConversationImageLinkRegula options:NSRegularExpressionCaseInsensitive error:&error];
    if (error == nil) {
        NSArray<NSTextCheckingResult *> *matches = [regularExpression matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        
        if (matches && matches.count) {
            
            [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *substringForMatch = [text substringWithRange:obj.range];//在原始文本查找对应字符串
                NSString *subAllString = [NSString stringWithFormat:@"＜comImg:%@＞",substringForMatch];
                NSRange subAllRange = [updateString rangeOfString:subAllString];//在修改后的文本中查找替代的位置
                [updateString replaceCharactersInRange:subAllRange withString:@""];
            }];
            
        }else{
            //NSLog(@"检索 图片 -------- 无检索结果");
        }
    }else{
        //NSLog(@"检索图片 === %@",error);
    }
    
    return updateString;
}

@end


#pragma mark - 输出框中的文字处理
@implementation ConversationContentParserTool (Input)

/* 将输入的文本转为富文本
 * 特殊格式： @某人、表情符号，其余不处理
 */
+ (NSMutableAttributedString *)transformAllAttributedInput:(NSAttributedString *)text font:(UIFont *)font color:(UIColor *)color
{
    NSMutableString *rawString = [ConversationContentParserTool getRawDataWithString:text];
    return [ConversationContentParserTool transformAllInput:rawString font:font color:color];
}

+ (NSMutableAttributedString *)transformAllInput:(NSString *)text font:(UIFont *)font color:(UIColor *)color{
    return [self parserContentWithText:text showImage:NO font:font color:color isInput:YES];
}

/* 将输入框的富文本完整还原为字符串
 */
+ (NSMutableString *)getRawDataWithString:(NSAttributedString *)parserString{
    NSMutableString *rawString = [[NSMutableString alloc] init];//结果
    if (parserString == nil) {
        return rawString;
    }
    
    //倒叙遍历
    [parserString enumerateAttributesInRange:NSMakeRange(0, parserString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSAttributedString *subAttributedString = [parserString attributedSubstringFromRange:range];
        NSString *subString = subAttributedString.string;
        if ([attrs.allKeys containsObject:NSConversationContentLinkAttributeName]) {
            ConversationContentLinkValueModel *valueModel = attrs[NSConversationContentLinkAttributeName];
            if (valueModel.linkType == ConversationContentLinkTypeImage){
                //查看图片 部分
                NSString *rollback = valueModel.otherInfo[@"rawData"];
                [rawString insertString:rollback atIndex:0];
            }else{
                [rawString insertString:subString atIndex:0];
            }
        }else if ([attrs.allKeys containsObject:NSConversationEmojiAttributeName]){
            //自定义表情 部分
            NSDictionary *expressionInfo = attrs[NSConversationEmojiAttributeName];
            NSString *name = expressionInfo.allValues.firstObject;
            [rawString insertString:name atIndex:0];
        }else{
            [rawString insertString:subString atIndex:0];
        }
    }];
    return rawString;
}


@end

#pragma mark - Emoji 表情

@implementation ConversationContentParserTool (Emoji)

/* 创建 Emoji
 */
+ (NSAttributedString *)getEmojiWithName:(NSString *)name font:(UIFont *)font{
    UIImage *image = [UIImage imageEmojiName:name];
    if (image) {
        return [ConversationContentParserTool getExpressionAttributedWithString:image font:font];
    }else{
        NSLog(@"emojiName === %@",name);
        return nil;
    }
}

/* 将 Emoji 表情 转为 富文本
 */
+ (NSAttributedString *)getExpressionAttributedWithString:(UIImage *)image font:(UIFont *)font{
    if (image) {
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, -2, font.lineHeight, font.lineHeight);//设置frame
        attchment.image = image;//设置图片
        NSAttributedString *imgaeString = [NSAttributedString attributedStringWithAttachment:attchment];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:imgaeString];
        [attributedString addAttribute:NSConversationEmojiAttributeName value:@{image.emojiCode:image.emojiName} range:NSMakeRange(0, attributedString.length)];
        return attributedString;
    }else{
        return nil;
    }
}

@end

