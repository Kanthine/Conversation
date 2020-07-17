//
//  HttpManager.m
//  objective_c_language
//
//  Created by 龙 on 2018/5/22.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetAPIClient.h"
#import "AFNetTools.h"

@interface HttpManager()

@end

@implementation HttpManager

#pragma mark - public method

+ (void)requestTest
{
    NSLog(@"IP地址：%@",[AFNetTools getIPAddress:YES]);
    [self requestForGetUrl:URL_Test success:^(id responseObject) {
    } failure:^(NSError *error) {
        NSLog(@"error --get--- %@",error);
    }];
}

+ (void)requestFileList
{
    [AFNetAPIClient.sharedClient GET:URL_File_List parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[AFNetAPIClient sharedClient] logSessionDataTask:task ResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (void)requestDownData
{
    [AFNetAPIClient.sharedClient GET:URL_Load_Header parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[AFNetAPIClient sharedClient] logSessionDataTask:task ResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - Private Method

+ (void)requestForGetUrl:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[AFNetAPIClient sharedClient] requestForGetUrl:url success:success failure:failure];

}

+ (void)requestForPostUrl:(NSString *)url Parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[AFNetAPIClient sharedClient] requestForPostUrl:url Parameters:parameters success:success failure:failure];
}



@end
