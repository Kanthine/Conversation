//
//  WebSocketClient.h
//  MyYummy
//
//  Created by 苏沫离 on 2019/5/23.
//  Copyright © 2019 Tomato FoodNet Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT int const kHeartBeatInterval;//心跳频率
FOUNDATION_EXPORT NSString *const kChatAddress;//心跳频率

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketClient : NSObject

@property (nonatomic ,copy) NSString *urlString;
@property (nonatomic ,copy) void(^receivedMessage)(NSDictionary *dict);
- (void)openSocketWithURL:(NSString *)urlString heartBeat:(NSDictionary *)dict;

- (void)sendString:(NSString *)string;
- (void)sendData:(NSDictionary *)dict;
- (void)closeSocket;

@end

NS_ASSUME_NONNULL_END
