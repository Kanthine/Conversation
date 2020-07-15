//
//  HttpManager.h
//  objective_c_language
//
//  Created by 龙 on 2018/5/22.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (void)requestTest;

//+ (void)requestCityListSuccess:(void (^)(NSMutableArray<CityListModel *> *cityArray))success failure:(void (^)(NSError *error))failure;

+ (void)requestForGetUrl:(NSString*)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)requestForPostUrl:(NSString*)url Parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (void)requestFileList;


+ (void)requestDownData;

@end

#import "HttpManager+UploadFile.h"
#import "HttpManager+LoginOrRegister.h"


/*
 Http/1.1 协议：
 
 
 
 */
