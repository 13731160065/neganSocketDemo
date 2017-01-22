//
//  SocketMnager.m
//  neganSocket
//
//  Created by 舞蹈圈 on 17/1/22.
//  Copyright © 2017年 negan. All rights reserved.
//

#import "SocketMnager.h"
#import "CocoaAsyncSocket.h"

static SocketMnager * manager;

@interface SocketMnager ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket * severSocket;
    GCDAsyncSocket * clientSocket;
}

@end

@implementation SocketMnager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SocketMnager alloc] init];
    });
    return manager;
}

- (void)setupSever {
    severSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("sss", DISPATCH_QUEUE_CONCURRENT)];
}

- (void)startSeverWithPort:(NSString *)port {
    NSError * err;
    [severSocket acceptOnPort:port.intValue error:&err];
    if (err) {
        NSLog(@"启动服务错误:%@", err);
    }
}

- (void)setupClient {
    clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("ccc", DISPATCH_QUEUE_CONCURRENT)];
}

- (void)connectSeverWithIP:(NSString *)ip port:(NSString *)port {
    NSError * err;
    [clientSocket connectToHost:ip onPort:port.intValue error:&err];
    if (err) {
        NSLog(@"客户端连接错误:%@", err);
    }
}

- (void)sendData:(NSData *)data {
    [clientSocket writeData:data withTimeout:30.0f tag:0];
}

#pragma mark - socket代理

@end
