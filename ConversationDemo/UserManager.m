//
//  UserManager.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserManager.h"


NSString *const kUserManagerNickName = @"nickName";
NSString *const kUserManagerHeadPath = @"photo";
NSString *const kUserManagerUserId = @"userID";
NSString *const kUserManagerToken = @"token";
NSString *const kUserManagerAccount = @"account";
NSString *const kUserManagerPassword = @"password";


@implementation UserManager

@synthesize nickName = _nickName;
@synthesize headPath = _headPath;
@synthesize userId = _userId;
@synthesize token = _token;
@synthesize account = _account;
@synthesize password = _password;

+ (instancetype)shareUser{
    static UserManager *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSData *data = [NSData dataWithContentsOfFile:UserManager.filePath];
        NSKeyedUnarchiver *unrachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        user = (UserManager *)[unrachiver decodeObject];
        [unrachiver finishDecoding];
        
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

- (void)parserWithDictionary:(NSDictionary *)dict{
    if([dict isKindOfClass:[NSDictionary class]]) {
        self.nickName = [self objectOrNilForKey:kUserManagerNickName fromDictionary:dict];
        self.headPath = [self objectOrNilForKey:kUserManagerHeadPath fromDictionary:dict];
        self.userId = [self objectOrNilForKey:@"id" fromDictionary:dict];
        self.token = [self objectOrNilForKey:kUserManagerToken fromDictionary:dict];
        self.account = [self objectOrNilForKey:kUserManagerAccount fromDictionary:dict];
    }
}

- (NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.account forKey:kUserManagerAccount];
    [mutableDict setValue:self.token forKey:kUserManagerToken];
    [mutableDict setValue:self.nickName forKey:kUserManagerNickName];
    [mutableDict setValue:self.headPath forKey:kUserManagerHeadPath];
    [mutableDict setValue:self.userId forKey:kUserManagerUserId];
    [mutableDict setValue:self.password forKey:kUserManagerPassword];
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
    self.account = [aDecoder decodeObjectForKey:kUserManagerAccount];
    self.token = [aDecoder decodeObjectForKey:kUserManagerToken];
    self.nickName = [aDecoder decodeObjectForKey:kUserManagerNickName];
    self.headPath = [aDecoder decodeObjectForKey:kUserManagerHeadPath];
    self.userId = [aDecoder decodeObjectForKey:kUserManagerUserId];
    self.password = [aDecoder decodeObjectForKey:kUserManagerPassword];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_token forKey:kUserManagerToken];
    [aCoder encodeObject:_account forKey:kUserManagerAccount];
    [aCoder encodeObject:_nickName forKey:kUserManagerNickName];
    [aCoder encodeObject:_headPath forKey:kUserManagerHeadPath];
    [aCoder encodeObject:_userId forKey:kUserManagerUserId];
    [aCoder encodeObject:_password forKey:kUserManagerPassword];
}

- (id)copyWithZone:(NSZone *)zone{
    UserManager *copy = [[UserManager alloc] init];
    if (copy) {
        copy.account = [self.account copyWithZone:zone];
        copy.token = [self.token copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.headPath = [self.headPath copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
    }
    return copy;
}

- (BOOL)save{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archive encodeObject:self];//encode 编码
    [archive finishEncoding];
    BOOL isSuccees = [data writeToFile:UserManager.filePath atomically:YES];
    return isSuccees;
}

+ (NSString *)filePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountInfo"];
}

@end

