//
//  ConversationModel.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationModel.h"
#import "ConversationContentParserTool.h"

NSString *const kConversationModelFromID = @"fromID";
NSString *const kConversationModelContent = @"content";
NSString *const kConversationModelMsgType = @"msgType";
NSString *const kConversationModelSendDate = @"sendDate";
NSString *const kConversationModelToName = @"toName";
NSString *const kConversationModelFromName = @"fromName";
NSString *const kConversationModelToHeaderPath = @"toHeaderPath";
NSString *const kConversationModelMsgId = @"msgId";
NSString *const kConversationModelGroup = @"group";
NSString *const kConversationModelFromHeaderPath = @"fromHeaderPath";
NSString *const kConversationModelToID = @"toID";


@implementation ConversationModel

@synthesize fromID = _fromID;
@synthesize content = _content;
@synthesize msgType = _msgType;
@synthesize sendDate = _sendDate;
@synthesize toName = _toName;
@synthesize fromName = _fromName;
@synthesize toHeaderPath = _toHeaderPath;
@synthesize msgId = _msgId;
@synthesize group = _group;
@synthesize fromHeaderPath = _fromHeaderPath;
@synthesize toID = _toID;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.fromID = [self objectOrNilForKey:kConversationModelFromID fromDictionary:dict];
        self.content = [self objectOrNilForKey:kConversationModelContent fromDictionary:dict];
        self.msgType = [self objectOrNilForKey:kConversationModelMsgType fromDictionary:dict];
        self.sendDate = [[self objectOrNilForKey:kConversationModelSendDate fromDictionary:dict] integerValue];
        self.toName = [self objectOrNilForKey:kConversationModelToName fromDictionary:dict];
        self.fromName = [self objectOrNilForKey:kConversationModelFromName fromDictionary:dict];
        self.toHeaderPath = [self objectOrNilForKey:kConversationModelToHeaderPath fromDictionary:dict];
        self.msgId = [self objectOrNilForKey:kConversationModelMsgId fromDictionary:dict];
        self.group = [[self objectOrNilForKey:kConversationModelGroup fromDictionary:dict] boolValue];
        self.fromHeaderPath = [self objectOrNilForKey:kConversationModelFromHeaderPath fromDictionary:dict];
        self.toID = [self objectOrNilForKey:kConversationModelToID fromDictionary:dict];
        [self parserExtraInfo];
    }
    return self;
}

extern CGFloat getConversationTableTextCellHeight(ConversationModel *model);
extern CGFloat kConversationTableSeatsCellHeight;
- (void)parserExtraInfo{
    if ([self.fromID isEqualToString:[NSString stringWithFormat:@"%@",UserManager.shareUser.userId]]) {
        self.direction = ConversationDirection_SEND;
    }else{
        self.direction = ConversationDirection_RECEIVE;
    }
    
    if (self.content == nil) {
        self.content = @"";
    }
    self.cellHeight = 0.01;
    if ([self.msgType isEqualToString:@"Text"]) {
        self.type = ConversationType_TEXT;
        self.attributedString = [ConversationContentParserTool parserContentWithText:self.content showImage:YES font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        CGFloat text_max_width = CGRectGetWidth(UIScreen.mainScreen.bounds) - (14 + 30 + 10) * 2.0 - 10 * 2.0;
        CGSize text_size = [self.attributedString boundingRectWithSize:CGSizeMake(text_max_width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.contentSize = text_size;
        self.cellHeight = getConversationTableTextCellHeight(self);
    }else if ([self.msgType isEqualToString:@"IMGTEXT"]){
        self.type = ConversationType_IMAGE;
    }
}

- (NSString *)description{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.fromID forKey:kConversationModelFromID];
    [mutableDict setValue:self.content forKey:kConversationModelContent];
    [mutableDict setValue:self.msgType forKey:kConversationModelMsgType];
    [mutableDict setValue:[NSNumber numberWithInteger:self.sendDate] forKey:kConversationModelSendDate];
    [mutableDict setValue:self.toName forKey:kConversationModelToName];
    [mutableDict setValue:self.fromName forKey:kConversationModelFromName];
    [mutableDict setValue:self.toHeaderPath forKey:kConversationModelToHeaderPath];
    [mutableDict setValue:self.msgId forKey:kConversationModelMsgId];
    [mutableDict setValue:[NSNumber numberWithBool:self.group] forKey:kConversationModelGroup];
    [mutableDict setValue:self.fromHeaderPath forKey:kConversationModelFromHeaderPath];
    [mutableDict setValue:self.toID forKey:kConversationModelToID];
    [mutableDict setValue:@(self.cellHeight) forKey:@"cellHeight"];
    return [NSString stringWithFormat:@"%@", mutableDict];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.fromID = [aDecoder decodeObjectForKey:kConversationModelFromID];
    self.content = [aDecoder decodeObjectForKey:kConversationModelContent];
    self.msgType = [aDecoder decodeObjectForKey:kConversationModelMsgType];
    self.sendDate = [aDecoder decodeIntegerForKey:kConversationModelSendDate];
    self.toName = [aDecoder decodeObjectForKey:kConversationModelToName];
    self.fromName = [aDecoder decodeObjectForKey:kConversationModelFromName];
    self.toHeaderPath = [aDecoder decodeObjectForKey:kConversationModelToHeaderPath];
    self.msgId = [aDecoder decodeObjectForKey:kConversationModelMsgId];
    self.group = [aDecoder decodeBoolForKey:kConversationModelGroup];
    self.fromHeaderPath = [aDecoder decodeObjectForKey:kConversationModelFromHeaderPath];
    self.toID = [aDecoder decodeObjectForKey:kConversationModelToID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_fromID forKey:kConversationModelFromID];
    [aCoder encodeObject:_content forKey:kConversationModelContent];
    [aCoder encodeObject:_msgType forKey:kConversationModelMsgType];
    [aCoder encodeInteger:_sendDate forKey:kConversationModelSendDate];
    [aCoder encodeObject:_toName forKey:kConversationModelToName];
    [aCoder encodeObject:_fromName forKey:kConversationModelFromName];
    [aCoder encodeObject:_toHeaderPath forKey:kConversationModelToHeaderPath];
    [aCoder encodeObject:_msgId forKey:kConversationModelMsgId];
    [aCoder encodeBool:_group forKey:kConversationModelGroup];
    [aCoder encodeObject:_fromHeaderPath forKey:kConversationModelFromHeaderPath];
    [aCoder encodeObject:_toID forKey:kConversationModelToID];
}

- (id)copyWithZone:(NSZone *)zone{
    ConversationModel *copy = [[ConversationModel alloc] init];
    if (copy) {
        copy.fromID = [self.fromID copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.msgType = [self.msgType copyWithZone:zone];
        copy.sendDate = self.sendDate;
        copy.toName = [self.toName copyWithZone:zone];
        copy.fromName = [self.fromName copyWithZone:zone];
        copy.toHeaderPath = [self.toHeaderPath copyWithZone:zone];
        copy.msgId = [self.msgId copyWithZone:zone];
        copy.group = self.group;
        copy.fromHeaderPath = [self.fromHeaderPath copyWithZone:zone];
        copy.toID = [self.toID copyWithZone:zone];
    }
    return copy;
}


@end
