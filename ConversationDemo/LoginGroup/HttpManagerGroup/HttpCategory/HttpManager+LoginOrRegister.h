//
//  HttpManager+LoginOrRegister.h
//  objective_c_language
//
//  Created by 苏沫离 on 2018/6/4.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "HttpManager.h"
#import "UserManager.h"
@interface HttpManager (LoginOrRegister)

+ (void)requestLoginWithAccount:(NSString *)account Password:(NSString *)password Success:(void (^)(UserManager *account))success failure:(void (^)(NSError *error))failure;

+ (void)requestRegisterWithAccount:(NSString *)account Password:(NSString *)password Email:(NSString *)email Success:(void (^)(UserManager *account))success failure:(void (^)(NSError *error))failure;


@end
