//
//  ConversationUserModel.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/27.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ConversationUserModel.h"

NSString *const kConversationUserModelNickName = @"nickName";
NSString *const kConversationUserModelHeadPath = @"photo";
NSString *const kConversationUserModelUserId = @"id";
NSString *const kConversationUserModelIsGroup = @"isGroup";
NSString *const kConversationUserModelAccount = @"account";


@implementation ConversationUserModel

@synthesize nickName = _nickName;
@synthesize headPath = _headPath;
@synthesize userId = _userId;
@synthesize account = _account;
@synthesize isGroup = _isGroup;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.nickName = [self objectOrNilForKey:kConversationUserModelNickName fromDictionary:dict];
        self.headPath = [self objectOrNilForKey:kConversationUserModelHeadPath fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kConversationUserModelUserId fromDictionary:dict];
        self.account = [self objectOrNilForKey:kConversationUserModelAccount fromDictionary:dict];
        self.isGroup = [[self objectOrNilForKey:kConversationUserModelIsGroup fromDictionary:dict] boolValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.nickName forKey:kConversationUserModelNickName];
    [mutableDict setValue:self.headPath forKey:kConversationUserModelHeadPath];
    [mutableDict setValue:self.userId forKey:kConversationUserModelUserId];
    [mutableDict setValue:self.account forKey:kConversationUserModelAccount];
    [mutableDict setValue:@(self.isGroup) forKey:kConversationUserModelIsGroup];
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
    self.nickName = [aDecoder decodeObjectForKey:kConversationUserModelNickName];
    self.headPath = [aDecoder decodeObjectForKey:kConversationUserModelHeadPath];
    self.userId = [aDecoder decodeObjectForKey:kConversationUserModelUserId];
    self.account = [aDecoder decodeObjectForKey:kConversationUserModelAccount];
    self.isGroup = [aDecoder decodeBoolForKey:kConversationUserModelIsGroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_nickName forKey:kConversationUserModelNickName];
    [aCoder encodeObject:_headPath forKey:kConversationUserModelHeadPath];
    [aCoder encodeObject:_userId forKey:kConversationUserModelUserId];
    [aCoder encodeObject:_account forKey:kConversationUserModelAccount];
    [aCoder encodeBool:_isGroup forKey:kConversationUserModelIsGroup];
}

- (id)copyWithZone:(NSZone *)zone{
    ConversationUserModel *copy = [[ConversationUserModel alloc] init];
    if (copy) {
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.headPath = [self.headPath copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.account = [self.account copyWithZone:zone];
        copy.isGroup = self.isGroup;
    }
    return copy;
}

@end


#import "ConversationDatabaseManager.h"
@implementation ConversationUserModel (DAO)



@end
