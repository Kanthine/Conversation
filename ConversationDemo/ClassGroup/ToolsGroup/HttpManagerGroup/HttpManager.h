//
//  HttpManager.h
//  objective_c_language
//
//  Created by 龙 on 2018/5/22.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestURL.h"
#import "AFNetAPIClient.h"

@interface HttpManager : NSObject

+ (void)requestTest;

+ (void)requestForGetUrl:(NSString*)url success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

+ (void)requestForPostUrl:(NSString*)url Parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

+ (void)uploadImage:(UIImage *)image success:(void(^)(NSString *url))successHandler error:(void(^)(NSString *error))errorHandler;


+ (void)requestDownData;

@end

