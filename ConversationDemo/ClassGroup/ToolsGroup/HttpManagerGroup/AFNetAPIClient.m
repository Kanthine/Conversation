//
//  AFNetAPIClient.m
//  objective_c_language
//
//  Created by 龙 on 2018/5/23.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "AFNetAPIClient.h"
#import <AFNetworking/AFURLRequestSerialization.h>
#import "UserManager.h"
#import "UIView+Toast.h"
@implementation AFNetAPIClient

/*
 * 创建一个单例类
 */
+(AFNetAPIClient*)sharedClient{
    static AFNetAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     
      NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
      
      NSURLCache* cache = [[NSURLCache alloc]initWithMemoryCapacity:10*1024*1024 diskCapacity:50*1024*1024 diskPath:nil];
      [config setURLCache:cache];
      
      NSURL *baseURL = [NSURL URLWithString:DOMAINBASE];
      _sharedClient = [[self alloc]initWithBaseURL:baseURL sessionConfiguration:config];
      _sharedClient.operationQueue.maxConcurrentOperationCount = 1;// 设置允许同时最大并发数量，过大容易出问题
      
      // 设置请求序列化器
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
      [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
      _sharedClient.requestSerializer.timeoutInterval = PostTimeOutInterval;
      [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
      _sharedClient.completionQueue = dispatch_queue_create("com.gcd.httpCompletionHandleDataQueue", DISPATCH_QUEUE_CONCURRENT);
 
        
      // 设置响应序列化器，解析Json对象
      AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
      responseSerializer.removesKeysWithNullValues = YES; // 清除返回数据的 NSNull
        responseSerializer.readingOptions = NSJSONReadingMutableContainers;
      responseSerializer.acceptableContentTypes = [NSSet setWithObjects:  @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil]; // 设置接受数据的格式
      _sharedClient.responseSerializer = responseSerializer;
      
        
      // 设置安全策略
//      _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];;

      [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  });

    return _sharedClient;
    
}

- (void)setSecurityPolicyClick{
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 设置安全策略
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    self.securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    self.securityPolicy.validatesDomainName = NO;
    self.securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
}



/** get 请求
 * url 请求地址
 *
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForGetUrl:(NSString*)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    //没有网络，返回无网络
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        NSError *error = [NSError errorWithDomain:@"没有网络" code:700 userInfo:nil];
        failure(error);
        return nil;
    }

    
    if ([url containsString:URL_CityList]){
        //是否可以使用该设备的蜂窝
        //设置后，该请求在 蜂窝 下无法联网
        self.requestSerializer.allowsCellularAccess = NO;
        
        //首先使用缓存，如果没有本地缓存，才从原地址下载

        [self.requestSerializer willChangeValueForKey:@"cachePolicy"];
        self.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        [self.requestSerializer didChangeValueForKey:@"cachePolicy"];
    }else{
        self.requestSerializer.allowsCellularAccess = YES;
        [self.requestSerializer willChangeValueForKey:@"cachePolicy"];
        self.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [self.requestSerializer didChangeValueForKey:@"cachePolicy"];
    }
    
    if (UserManager.shareUser.token){
        /*
         Authorization：授权信息，通常出现在对服务器发送的WWW-Authenticate头的应答中。
         主要用于证明客户端有权查看某个资源。
         当客户端访问一个页面时，如果收到服务器的响应代码为401（未授权），可以发送一个包含Authorization请求报头域的请求，要求服务器对其进行验证。
         */
        
        [self.requestSerializer setValue:UserManager.shareUser.token forHTTPHeaderField:@"Authorization"];

//        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:UserManager.shareUser.account password:UserManager.shareUser.password];
    }
    
    NSURLSessionDataTask* task =  [self GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self cacheCookie:task.response];
        [self logSessionDataTask:task ResponseObject:responseObject];

        if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) {// 若解析数据格式异常，返回错误
            NSError *error = [NSError errorWithDomain:@"数据异常" code:100 userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }else{
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
    return task;
    
}

/** post 请求
 * url 请求地址
 * parameters 请求参数 为nil
 *
 * cacheType 缓存类型
 *
 * isCacheData 返回的数据是否是本地缓存数据
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForPostUrl:(NSString*)url Parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    //没有网络，返回无网络
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){
        NSError *error = [NSError errorWithDomain:@"没有网络" code:700 userInfo:nil];
        failure(error);
        return nil;
    }
    NSURLSessionDataTask* task = [self POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:NSData.class]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        
        [self cacheCookie:task.response];
        [self logSessionDataTask:task ResponseObject:responseObject];
        
        if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])){// 若解析数据格式异常，返回错误
            NSError *error = [NSError errorWithDomain:@"数据异常" code:100 userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }else{
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"0"]) {
                NSError *error = [NSError errorWithDomain:responseObject[@"message"] code:100 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }else{
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
        
    }];
    return task;
}


+ (void)uploadImage:(UIImage *)image success:(void(^)(NSString *url))successHandler error:(void(^)(NSString *error))errorHandler{
    
    [AFNetAPIClient.sharedClient POST:@"api/user/upload/account/photo" parameters:@{} headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = [AFNetAPIClient compressImageSize:image toByte:9 * 1024 * 1024];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:NSData.class]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }

        if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])){// 若解析数据格式异常，返回错误
            dispatch_async(dispatch_get_main_queue(), ^{
                errorHandler(@"数据异常");
            });
        }else{
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(responseObject[@"message"]);
                });
            }else{
                NSString *url = responseObject[@"data"];
                if (![url hasPrefix:@"http"]) {
                    url = [NSString stringWithFormat:@"%@%@",DOMAINBASE,url];
                }
                NSLog(@"上传成功 ------ %@",url);
                dispatch_async(dispatch_get_main_queue(), ^{
                    successHandler(url);
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 ------ %@",error.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            errorHandler(error.description);
        });
    }];
}




- (void)cacheCookie:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *cookie = httpResponse.allHeaderFields[@"Set-Cookie"];
    [AFNetAPIClient storeCookie:cookie];
}

+ (void)storeCookie:(NSString *)cookie{
    if (cookie){
        [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"cookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)readCookie{
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"];
    if (cookie){
        return cookie;
    }
    return @"";
}

- (void)logSessionDataTask:(NSURLSessionDataTask *)task ResponseObject:(id  _Nullable) responseObject
{
    printf("\n \n \n \n ******** 打印 SessionDataTask 开始******** \n");

    if ([responseObject isKindOfClass:[NSDictionary class]]){
        if ([responseObject[@"code"] intValue] != 0){
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [UIApplication.sharedApplication.keyWindow makeToast:responseObject[@"message"] duration:5 position:CSToastPositionCenter];
            }];
        }
    }
    
    NSURLRequest *request = task.currentRequest;
    
    NSLog(@"\n --------- currentRequest --------- \n URL:%@ \n cachePolicy:%lu \n timeoutInterval:%f \n mainDocumentURL : %@ \n networkServiceType : %lu \n HTTPMethod : %@ \n allowsCellularAccess: %d \n HTTPShouldHandleCookies : %d \n HTTPShouldUsePipelining:%d \n allHTTPHeaderFields: %@ \n --------- response --------- \n response : %@ \n --------- responseObject --------- \n responseObject : %@",request.URL,(unsigned long)request.cachePolicy,request.timeoutInterval,request.mainDocumentURL,request.networkServiceType,request.HTTPMethod,request.allowsCellularAccess,request.HTTPShouldHandleCookies,request.HTTPShouldUsePipelining,request.allHTTPHeaderFields,task.response,[self unicodeFilterFromDic:responseObject]);
    
    
    printf("\n ******** 打印 SessionDataTask 结束******** \n \n \n");
}

- (NSString *)unicodeFilterFromDic:(NSDictionary *)responseObject
{
    if (responseObject == nil)
    {
        return @"";
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}



@end
