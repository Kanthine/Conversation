//
//  ConversationModel.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2019/9/17.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import "ConversationModel.h"
#import "ConversationContentParserTool.h"


NSString *const kConversationModelSeatsContentOrderNo = @"orderNo";
NSString *const kConversationModelSeatsContentPersonCount = @"personCount";
NSString *const kConversationModelSeatsContentState = @"state";
NSString *const kConversationModelSeatsContentShopImage = @"shopImage";
NSString *const kConversationModelSeatsContentSeatType = @"seatType";
NSString *const kConversationModelSeatsContentReserveTime = @"reserveTime";

@implementation ConversationModelSeatsContent

@synthesize orderNo = _orderNo;
@synthesize personCount = _personCount;
@synthesize state = _state;
@synthesize shopImage = _shopImage;
@synthesize seatType = _seatType;
@synthesize reserveTime = _reserveTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.orderNo = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationModelSeatsContentOrderNo fromDictionary:dict]];
            self.personCount = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationModelSeatsContentPersonCount fromDictionary:dict]];
            self.state = [self objectOrNilForKey:kConversationModelSeatsContentState fromDictionary:dict];
            self.shopImage = [self objectOrNilForKey:kConversationModelSeatsContentShopImage fromDictionary:dict];
            self.seatType = [self objectOrNilForKey:kConversationModelSeatsContentSeatType fromDictionary:dict];
            self.reserveTime = [self objectOrNilForKey:kConversationModelSeatsContentReserveTime fromDictionary:dict];
    }
    return self;
}

- (NSString *)description{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.orderNo forKey:kConversationModelSeatsContentOrderNo];
    [mutableDict setValue:self.personCount forKey:kConversationModelSeatsContentPersonCount];
    [mutableDict setValue:self.state forKey:kConversationModelSeatsContentState];
    [mutableDict setValue:self.shopImage forKey:kConversationModelSeatsContentShopImage];
    [mutableDict setValue:self.seatType forKey:kConversationModelSeatsContentSeatType];
    [mutableDict setValue:self.reserveTime forKey:kConversationModelSeatsContentReserveTime];
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
    self.orderNo = [aDecoder decodeObjectForKey:kConversationModelSeatsContentOrderNo];
    self.personCount = [aDecoder decodeObjectForKey:kConversationModelSeatsContentPersonCount];
    self.state = [aDecoder decodeObjectForKey:kConversationModelSeatsContentState];
    self.shopImage = [aDecoder decodeObjectForKey:kConversationModelSeatsContentShopImage];
    self.seatType = [aDecoder decodeObjectForKey:kConversationModelSeatsContentSeatType];
    self.reserveTime = [aDecoder decodeObjectForKey:kConversationModelSeatsContentReserveTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_orderNo forKey:kConversationModelSeatsContentOrderNo];
    [aCoder encodeObject:_personCount forKey:kConversationModelSeatsContentPersonCount];
    [aCoder encodeObject:_state forKey:kConversationModelSeatsContentState];
    [aCoder encodeObject:_shopImage forKey:kConversationModelSeatsContentShopImage];
    [aCoder encodeObject:_seatType forKey:kConversationModelSeatsContentSeatType];
    [aCoder encodeObject:_reserveTime forKey:kConversationModelSeatsContentReserveTime];
}

- (id)copyWithZone:(NSZone *)zone{
    ConversationModelSeatsContent *copy = [[ConversationModelSeatsContent alloc] init];
    if (copy) {
        copy.orderNo = [self.orderNo copyWithZone:zone];
        copy.personCount = [self.personCount copyWithZone:zone];
        copy.state = [self.state copyWithZone:zone];
        copy.shopImage = [self.shopImage copyWithZone:zone];
        copy.seatType = [self.seatType copyWithZone:zone];
        copy.reserveTime = [self.reserveTime copyWithZone:zone];
    }
    return copy;
}

@end







NSString *const kConversationModelSendUserId = @"sendUserId";
NSString *const kConversationModelContent = @"content";
NSString *const kConversationModelMessageType = @"messageType";
NSString *const kConversationModelReceUserId = @"receUserId";
NSString *const kConversationModelSendDate = @"sendDate";
NSString *const kConversationModelMsgId = @"msgId";

@implementation ConversationModel

@synthesize sendUserId = _sendUserId;
@synthesize content = _content;
@synthesize messageType = _messageType;
@synthesize receUserId = _receUserId;
@synthesize sendDate = _sendDate;
@synthesize msgId = _msgId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.sendUserId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationModelSendUserId fromDictionary:dict]];
        self.sendDate = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationModelSendDate fromDictionary:dict]];
        self.msgId = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationModelMsgId fromDictionary:dict]];
        self.content = [self objectOrNilForKey:kConversationModelContent fromDictionary:dict];
        self.messageType = [self objectOrNilForKey:kConversationModelMessageType fromDictionary:dict];
        self.receUserId = [self objectOrNilForKey:kConversationModelReceUserId fromDictionary:dict];
        
        [self parserExtraInfo];
    }
    return self;
}

extern CGFloat getConversationTableTextCellHeight(ConversationModel *model);
extern CGFloat kConversationTableSeatsCellHeight;
- (void)parserExtraInfo{
    if ([self.sendUserId isEqualToString:[NSString stringWithFormat:@"%@",@""]]) {
        self.direction = ConversationDirection_SEND;
    }else{
        self.direction = ConversationDirection_RECEIVE;
    }
    
    if (self.content == nil) {
        self.content = @"";
    }
    self.cellHeight = 0.01;
    if ([self.messageType isEqualToString:@"TEXT"]) {
        self.type = ConversationType_TEXT;
        self.attributedString = [ConversationContentParserTool parserContentWithText:self.content showImage:YES font:[UIFont systemFontOfSize:15] color:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        CGFloat text_max_width = CGRectGetWidth(UIScreen.mainScreen.bounds) - (14 + 30 + 10) * 2.0 - 10 * 2.0;
        CGSize text_size = [self.attributedString boundingRectWithSize:CGSizeMake(text_max_width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.contentSize = text_size;
        self.cellHeight = getConversationTableTextCellHeight(self);
    }else if ([self.messageType isEqualToString:@"SEATBOOK"]){
        self.type = ConversationType_Seats;
        self.cellHeight = kConversationTableSeatsCellHeight;
        NSData *jsonData = [self.content dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if(error){
            NSLog(@"json解析失败：%@",error);
        }else{
            self.seatsInfo = [ConversationModelSeatsContent modelObjectWithDictionary:dict];
        }
    }else if ([self.messageType isEqualToString:@"ORDER"]){
        self.type = ConversationType_ORDER;
    }else if ([self.messageType isEqualToString:@"IMGTEXT"]){
        self.type = ConversationType_IMAGE;
    }
}

- (NSString *)description{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msgId forKey:kConversationModelMsgId];
    [mutableDict setValue:self.sendDate forKey:kConversationModelSendDate];
    [mutableDict setValue:self.sendUserId forKey:kConversationModelSendUserId];
    [mutableDict setValue:self.content forKey:kConversationModelContent];
    [mutableDict setValue:self.messageType forKey:kConversationModelMessageType];
    [mutableDict setValue:self.receUserId forKey:kConversationModelReceUserId];
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
    self.msgId = [aDecoder decodeObjectForKey:kConversationModelMsgId];
    self.sendDate = [aDecoder decodeObjectForKey:kConversationModelSendDate];
    self.sendUserId = [aDecoder decodeObjectForKey:kConversationModelSendUserId];
    self.content = [aDecoder decodeObjectForKey:kConversationModelContent];
    self.messageType = [aDecoder decodeObjectForKey:kConversationModelMessageType];
    self.receUserId = [aDecoder decodeObjectForKey:kConversationModelReceUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_msgId forKey:kConversationModelMsgId];
    [aCoder encodeObject:_sendDate forKey:kConversationModelSendDate];
    [aCoder encodeObject:_sendUserId forKey:kConversationModelSendUserId];
    [aCoder encodeObject:_content forKey:kConversationModelContent];
    [aCoder encodeObject:_messageType forKey:kConversationModelMessageType];
    [aCoder encodeObject:_receUserId forKey:kConversationModelReceUserId];
}

- (id)copyWithZone:(NSZone *)zone{
    ConversationModel *copy = [[ConversationModel alloc] init];
    if (copy) {
        copy.msgId = [self.msgId copyWithZone:zone];
        copy.sendDate = [self.sendDate copyWithZone:zone];
        copy.sendUserId = [self.sendUserId copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.messageType = [self.messageType copyWithZone:zone];
        copy.receUserId = [self.receUserId copyWithZone:zone];
    }
    return copy;
}


@end
