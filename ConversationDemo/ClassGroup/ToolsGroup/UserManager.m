//
//  UserManager.m
//  ConversationDemo
//
//  Created by 苏沫离 on 2020/7/14.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "UserManager.h"
#import "RequestURL.h"
#import "AppDelegate.h"

#import "ConversationListViewController.h"
#import "LoginViewController.h"
#import "UINavigationController+TransitionAnimation.h"
#import "UserHomePageViewController.h"

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
        NSLog(@"user ----- %@",user);

        if (!user) {
            user = [[UserManager alloc] init];
        }
    });
    return user;;
}

- (NSString *)headPath{
    if (![_headPath hasPrefix:@"http"]) {
        _headPath = [NSString stringWithFormat:@"%@%@",DOMAINBASE,_headPath];
    }
    
    return _headPath;
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
    NSLog(@"initWithCoder ==== %@",self);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_token forKey:kUserManagerToken];
    [aCoder encodeObject:_account forKey:kUserManagerAccount];
    [aCoder encodeObject:_nickName forKey:kUserManagerNickName];
    [aCoder encodeObject:_headPath forKey:kUserManagerHeadPath];
    [aCoder encodeObject:_userId forKey:kUserManagerUserId];
    [aCoder encodeObject:_password forKey:kUserManagerPassword];
    NSLog(@"encodeWithCoder ==== %@",self);
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
    NSLog(@"save ==== %d ----- %@",isSuccees,self);
    NSLog(@"filePath ----- %@",UserManager.filePath);
    return isSuccees;
}

+ (NSString *)filePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountInfo"];
}

+ (void)setRootController{
    if (UserManager.shareUser.nickName) {
        ConversationListViewController *conversationListVC = [[ConversationListViewController alloc]init];
        UINavigationController *conversationListNAV = [[UINavigationController alloc] initWithRootViewController:conversationListVC];
        conversationListNAV.tabBarItem.title = @"会话";
        conversationListNAV.tabBarItem.image = [UIImage imageNamed:@"home"];
        conversationListNAV.tabBarItem.selectedImage = [UIImage imageNamed:@"home_select"];
        
        UserHomePageViewController *userHomeVC = [[UserHomePageViewController alloc]initWithUserId:UserManager.shareUser.userId];
        UINavigationController *userHomeNAV = [[UINavigationController alloc] initWithRootViewController:userHomeVC];
        userHomeNAV.tabBarItem.title = @"我的";
        userHomeNAV.tabBarItem.image = [UIImage imageNamed:@"mine"];
        userHomeNAV.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_select"];
        
        UITabBarController *tabController = [[UITabBarController alloc] init];
        tabController.tabBar.barTintColor = [UIColor whiteColor];
        tabController.tabBar.tintColor = [UIColor colorWithRed:241/255.0 green:78/255.0 blue:36/255.0 alpha:1.0];
//        [tabController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
//        [tabController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:241/255.0 green:78/255.0 blue:36/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
        tabController.tabBar.backgroundImage = [UserManager loadTabBarAndNavBarBackgroundImage];
        tabController.view.backgroundColor=[UIColor whiteColor];
        tabController.viewControllers = @[conversationListNAV,userHomeNAV];
        UIApplication.sharedApplication.delegate.window.rootViewController = tabController;
        [WebSocketClient shareClient];
        
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNav.delegate = loginNav;
        loginNav.transitionType = TransitionAnimationTypeFlip;
        loginNav.navigationBarHidden = YES;
        UIApplication.sharedApplication.delegate.window.rootViewController = loginNav;
    }
}


+ (UIImage *)loadTabBarAndNavBarBackgroundImage{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end

