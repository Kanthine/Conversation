//
//  UserInfoModel.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserInfoModel.h"

NSString *const kUserInfoModelNickName = @"nickName";
NSString *const kUserInfoModelHeadPath = @"photo";
NSString *const kUserInfoModelUserId = @"id";
NSString *const kUserInfoModelIsGroup = @"isGroup";



@implementation UserInfoModel

@synthesize nickName = _nickName;
@synthesize headPath = _headPath;
@synthesize userId = _userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.nickName = [self objectOrNilForKey:kUserInfoModelNickName fromDictionary:dict];
        self.headPath = [self objectOrNilForKey:kUserInfoModelHeadPath fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kUserInfoModelUserId fromDictionary:dict];
        self.isGroup = [[self objectOrNilForKey:kUserInfoModelIsGroup fromDictionary:dict] boolValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nickName forKey:kUserInfoModelNickName];
    [mutableDict setValue:self.headPath forKey:kUserInfoModelHeadPath];
    [mutableDict setValue:self.userId forKey:kUserInfoModelUserId];
    [mutableDict setValue:@(self.isGroup) forKey:kUserInfoModelIsGroup];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.nickName = [aDecoder decodeObjectForKey:kUserInfoModelNickName];
    self.headPath = [aDecoder decodeObjectForKey:kUserInfoModelHeadPath];
    self.userId = [aDecoder decodeObjectForKey:kUserInfoModelUserId];
    self.isGroup = [aDecoder decodeBoolForKey:kUserInfoModelIsGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_nickName forKey:kUserInfoModelNickName];
    [aCoder encodeObject:_headPath forKey:kUserInfoModelHeadPath];
    [aCoder encodeObject:_userId forKey:kUserInfoModelUserId];
    [aCoder encodeBool:_isGroup forKey:kUserInfoModelIsGroup];
}

- (id)copyWithZone:(NSZone *)zone{
    UserInfoModel *copy = [[UserInfoModel alloc] init];
    if (copy) {
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.headPath = [self.headPath copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.isGroup = self.isGroup;
    }
    return copy;
}

@end

