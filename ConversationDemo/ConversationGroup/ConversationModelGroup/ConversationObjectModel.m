//
//  ConversationObjectModel.m
//
//  Created by 沫离 苏 on 2019/9/17
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

#import "ConversationObjectModel.h"

NSString *const kConversationObjectModelCurUserImage = @"curUserImage";
NSString *const kConversationObjectModelMobile = @"mobile";
NSString *const kConversationObjectModelTwoMsg = @"twoMsg";
NSString *const kConversationObjectModelShopNo = @"shopNo";
NSString *const kConversationObjectModelShopUserId = @"shopUserId";
NSString *const kConversationObjectModelShopName = @"shopName";
NSString *const kConversationObjectModelShopUserImage = @"shopUserImage";


@interface ConversationObjectModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ConversationObjectModel

@synthesize curUserImage = _curUserImage;
@synthesize mobile = _mobile;
@synthesize shopNo = _shopNo;
@synthesize shopUserId = _shopUserId;
@synthesize shopName = _shopName;
@synthesize shopUserImage = _shopUserImage;

- (void)parserObjectWithDictionary:(NSDictionary *)dict{
    if([dict isKindOfClass:[NSDictionary class]]) {
        self.curUserImage = [self objectOrNilForKey:kConversationObjectModelCurUserImage fromDictionary:dict];
        self.mobile = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:kConversationObjectModelMobile fromDictionary:dict]];
        self.shopNo = [self objectOrNilForKey:kConversationObjectModelShopNo fromDictionary:dict];
        self.shopUserId = [self objectOrNilForKey:kConversationObjectModelShopUserId fromDictionary:dict];
        self.shopName = [self objectOrNilForKey:kConversationObjectModelShopName fromDictionary:dict];
        self.shopUserImage = [self objectOrNilForKey:kConversationObjectModelShopUserImage fromDictionary:dict];
    }
}

- (NSString *)description {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.curUserImage forKey:kConversationObjectModelCurUserImage];
    [mutableDict setValue:self.mobile forKey:kConversationObjectModelMobile];
    [mutableDict setValue:self.shopNo forKey:kConversationObjectModelShopNo];
    [mutableDict setValue:self.shopUserId forKey:kConversationObjectModelShopUserId];
    [mutableDict setValue:self.shopName forKey:kConversationObjectModelShopName];
    [mutableDict setValue:self.shopUserImage forKey:kConversationObjectModelShopUserImage];
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
    self.curUserImage = [aDecoder decodeObjectForKey:kConversationObjectModelCurUserImage];
    self.mobile = [aDecoder decodeObjectForKey:kConversationObjectModelMobile];
    self.shopNo = [aDecoder decodeObjectForKey:kConversationObjectModelShopNo];
    self.shopUserId = [aDecoder decodeObjectForKey:kConversationObjectModelShopUserId];
    self.shopName = [aDecoder decodeObjectForKey:kConversationObjectModelShopName];
    self.shopUserImage = [aDecoder decodeObjectForKey:kConversationObjectModelShopUserImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_curUserImage forKey:kConversationObjectModelCurUserImage];
    [aCoder encodeObject:_mobile forKey:kConversationObjectModelMobile];
    [aCoder encodeObject:_shopNo forKey:kConversationObjectModelShopNo];
    [aCoder encodeObject:_shopUserId forKey:kConversationObjectModelShopUserId];
    [aCoder encodeObject:_shopName forKey:kConversationObjectModelShopName];
    [aCoder encodeObject:_shopUserImage forKey:kConversationObjectModelShopUserImage];
}

- (id)copyWithZone:(NSZone *)zone{
    ConversationObjectModel *copy = [[ConversationObjectModel alloc] init];
    if (copy) {
        copy.curUserImage = [self.curUserImage copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.shopNo = [self.shopNo copyWithZone:zone];
        copy.shopUserId = [self.shopUserId copyWithZone:zone];
        copy.shopName = [self.shopName copyWithZone:zone];
        copy.shopUserImage = [self.shopUserImage copyWithZone:zone];
    }
    
    return copy;
}


@end
