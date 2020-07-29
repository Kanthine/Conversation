//
//  WebSocketClient.m
//  Conversation
//
//  Created by 苏沫离 on 2019/5/23.
//  Copyright © 2019 苏沫离. All rights reserved.
//


#import "WebSocketClient.h"
#import <SocketRocket.h>
#import <AFNetworkReachabilityManager.h>
#import "UserManager.h"

static int const kHeartBeatInterval = 5;

///收到消息
NSString * const kSocketReceiveMessageNotification = @"socket.receive";

NSString * _Nonnull const kSocketLinkStateNotification = @"socket.linkState";
NSString * _Nonnull const kSocketOnLineInfoKey = @"socket.onLine";

///长链接
NSString * _Nonnull getSocketLink(void){
    NSString *link = [NSString stringWithFormat:@"ws://route.51mypc.cn/wss/im-chat/%@",UserManager.shareUser.token];
    NSLog(@"link ===== %@",link);
    return link;
}


@interface WebSocketClient ()
<SRWebSocketDelegate>

{
    int _reconnectionCount;//失败后，重连次数
    NSTimer *_heartBeatTimer;
    SRWebSocket *_socket;
}

@property (nonatomic ,assign) int reconnectionCount;//失败后，重连次数
@property (nonatomic ,strong) AFNetworkReachabilityManager *networkManager;
@property (nonatomic ,copy) NSDictionary *heartBeatDict;

@end

@implementation WebSocketClient

+ (instancetype)shareClient{
    static WebSocketClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[WebSocketClient alloc] init];
        [client openSocketWithURL:getSocketLink() heartBeat:@{}];
    });
    return client;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isOnLine = NO;
        _reconnectionCount = 0;
        _networkManager = [AFNetworkReachabilityManager managerForDomain:@"http://route.51mypc.cn"];
        [_networkManager startMonitoring];
    }
    return self;
}

#pragma mark - public method

- (void)openSocketWithURL:(NSString *)urlString heartBeat:(NSDictionary *)dict{
    [self closeSocket];
    self.urlString = urlString;
    self.heartBeatDict = dict;
    _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    _socket.delegate = self;
    [_socket open];
}

/** 重新链接
 */
- (void)recoverSocket{
    [self openSocketWithURL:self.urlString heartBeat:self.heartBeatDict];//重新开启
}

- (void)closeSocket{
    [_socket close];//关闭连接
    _socket = nil;
    
    [_heartBeatTimer invalidate];//停止心跳
    _heartBeatTimer = nil;
}

- (void)sendString:(NSString *)string{
    [_socket send:string];
}

- (void)sendData:(NSDictionary *)dict{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [_socket send:str];
}

- (void)heartBeatClick{
    if (self.heartBeatDict && self.heartBeatDict.allKeys.count > 0) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.heartBeatDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [_socket send:str];
    }else{
        [_socket sendPing:nil];
    }
}

- (void)setIsOnLine:(BOOL)isOnLine{
    if (_isOnLine != isOnLine) {
        _isOnLine = isOnLine;
        [NSNotificationCenter.defaultCenter postNotificationName:kSocketLinkStateNotification object:nil userInfo:@{kSocketOnLineInfoKey:@(isOnLine)}];
    }
}

#pragma mark - SRWebSocketDelegate

/** Socket 已经与服务器连接成功
 * 发送心跳包，获取数据
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if (_heartBeatTimer == nil && _socket == webSocket && webSocket.readyState == SR_OPEN) {
        [self heartBeatClick];
        _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:kHeartBeatInterval target:self selector:@selector(heartBeatClick) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:_heartBeatTimer forMode:NSRunLoopCommonModes];
    }
    self.isOnLine = YES;
}

/* 收到后台返回的数据
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"SRWebSocket : didReceiveMessage ------ %@",message);
    _reconnectionCount = 0;
    NSDictionary *dict;
    if ([message isKindOfClass:[NSString class]]) {
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }else if ([message isKindOfClass:NSDictionary.class]){
        dict = message;
    }
    
    if (dict) {
        [NSNotificationCenter.defaultCenter postNotificationName:kSocketReceiveMessageNotification object:nil userInfo:dict];
        if(self.receivedMessage) {
            self.receivedMessage(dict);
        }
    }
}

/** 连接失败,实现掉线自动重连
 * @note 判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连
 * @note 连接次数限制，如果连接失败了，重试10次就不再重试
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"SRWebSocket : didFailWithError ------ %@",error);
    [self closeSocket];//关闭连接
    if (_networkManager.reachable) {
        if (_reconnectionCount < 10) {
            _reconnectionCount ++;
            [self recoverSocket];//重新开启
        }else{
            self.isOnLine = NO;
        }
    }else{
        __weak typeof(self) weakSelf = self;
        [_networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusReachableViaWWAN ||
                status == AFNetworkReachabilityStatusReachableViaWiFi) {
                NSLog(@"SRWebSocket : 有网络");
                if (weakSelf.urlString && weakSelf.heartBeatDict) {
                    NSLog(@"SRWebSocket : 有网络 -> 重新开启");
                    [weakSelf recoverSocket];//重新开启
                }else{
                    weakSelf.isOnLine = NO;
                }
            }else{
                weakSelf.isOnLine = NO;
                NSLog(@"SRWebSocket : 网络断开");
            }
        }];
    }
}

/** 连接断开
 * @note 清空socket对象;关闭心跳
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"SRWebSocket : didCloseWithCode ------ %@",reason);
    [self closeSocket];
    self.isOnLine = NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *string = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"SRWebSocket : didReceivePong ---------- %@",string);
}

@end
