//
//  UserManager.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserManager.h"


NSString *const kUserManagerMobile = @"mobile";
NSString *const kUserManagerNickName = @"nickName";
NSString *const kUserManagerHeadPath = @"headPath";
NSString *const kUserManagerUserId = @"userId";

@implementation UserManager

@synthesize mobile = _mobile;
@synthesize nickName = _nickName;
@synthesize headPath = _headPath;
@synthesize userId = _userId;

+ (instancetype)shareUser{
    static UserManager *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = (UserManager *)[NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserInfo"]];
        if (!user) {
            user = [[UserManager alloc] init];
        }
    });
    return user;;
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    if (nickName.length > 0) {
        [self save];
    }
}


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.mobile = [self objectOrNilForKey:kUserManagerMobile fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kUserManagerNickName fromDictionary:dict];
        self.headPath = [self objectOrNilForKey:kUserManagerHeadPath fromDictionary:dict];
        self.userId = [self objectOrNilForKey:kUserManagerUserId fromDictionary:dict];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.mobile forKey:kUserManagerMobile];
    [mutableDict setValue:self.nickName forKey:kUserManagerNickName];
    [mutableDict setValue:self.headPath forKey:kUserManagerHeadPath];
    [mutableDict setValue:self.userId forKey:kUserManagerUserId];
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
    self.mobile = [aDecoder decodeObjectForKey:kUserManagerMobile];
    self.nickName = [aDecoder decodeObjectForKey:kUserManagerNickName];
    self.headPath = [aDecoder decodeObjectForKey:kUserManagerHeadPath];
    self.userId = [aDecoder decodeObjectForKey:kUserManagerUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_mobile forKey:kUserManagerMobile];
    [aCoder encodeObject:_nickName forKey:kUserManagerNickName];
    [aCoder encodeObject:_headPath forKey:kUserManagerHeadPath];
    [aCoder encodeObject:_userId forKey:kUserManagerUserId];
}

- (id)copyWithZone:(NSZone *)zone{
    UserManager *copy = [[UserManager alloc] init];
    if (copy) {
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.headPath = [self.headPath copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
    }
    return copy;
}

- (void)save{
    [NSKeyedArchiver archiveRootObject:self toFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserInfo"]];
}

@end

