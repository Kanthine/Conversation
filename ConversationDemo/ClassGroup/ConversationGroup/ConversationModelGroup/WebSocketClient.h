//
//  WebSocketClient.h
//  Conversation
//
//  Created by 苏沫离 on 2019/5/23.
//  Copyright © 2019 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nonnull getSocketLink(void);//长链接
FOUNDATION_EXPORT NSString * _Nonnull const kSocketReceiveMessageNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kSocketLinkStateNotification;
FOUNDATION_EXPORT NSString * _Nonnull const kSocketOnLineInfoKey;

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketClient : NSObject

@property (nonatomic ,assign) BOOL isOnLine;///是否在线
@property (nonatomic ,copy) NSString *urlString;
@property (nonatomic ,copy) void(^receivedMessage)(NSDictionary *dict);

/** 获取单例
*/
+ (instancetype)shareClient;

/** 打开链接
 * @param urlString 地址
 * @param dict 心跳包数据
 */
- (void)openSocketWithURL:(NSString *)urlString heartBeat:(NSDictionary *)dict;

/** 重新链接
 */
- (void)recoverSocket;

/** 关闭链接
 */
- (void)closeSocket;


/** 向服务端发送数据
 */
- (void)sendString:(NSString *)string;
- (void)sendData:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
