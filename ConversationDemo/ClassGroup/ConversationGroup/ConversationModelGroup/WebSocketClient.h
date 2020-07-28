//
//  WebSocketClient.h
//  MyYummy
//
//  Created by 苏沫离 on 2019/5/23.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nonnull getSocketLink(void);//长链接
FOUNDATION_EXPORT NSString * _Nonnull const kSocketReceiveMessageNotification;

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketClient : NSObject

@property (nonatomic ,copy) NSString *urlString;
@property (nonatomic ,copy) void(^receivedMessage)(NSDictionary *dict);

+ (instancetype)shareClient;


- (void)openSocketWithURL:(NSString *)urlString heartBeat:(NSDictionary *)dict;

- (void)sendString:(NSString *)string;
- (void)sendData:(NSDictionary *)dict;
- (void)closeSocket;

@end

NS_ASSUME_NONNULL_END
