//
//  HttpManager.m
//  objective_c_language
//
//  Created by 龙 on 2018/5/22.
//  Copyright © 2018年 longlong. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetTools.h"

@interface HttpManager()

@end

@implementation HttpManager

#pragma mark - public method

+ (void)requestForGetUrl:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    [[AFNetAPIClient sharedClient] requestForGetUrl:url success:success failure:failure];

}

+ (void)requestForPostUrl:(NSString *)url Parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    [[AFNetAPIClient sharedClient] requestForPostUrl:url Parameters:parameters success:success failure:failure];
}

+ (void)uploadImage:(UIImage *)image success:(void(^)(NSString *url))successHandler error:(void(^)(NSString *error))errorHandler{
    [AFNetAPIClient.sharedClient POST:@"api/user/upload/picture" parameters:@{} headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [HttpManager compressImageSize:image toByte:9 * 1024 * 1024];
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


#pragma mark - Private Method

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
