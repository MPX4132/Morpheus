//
//  OPLHumanAI.m
//  Morpheus
//
//  Created by Matias Barcenas on 4/27/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import "OPLHumanAI.h"

//  Notice: Everything in this file is private!

@interface OPLHumanAI() {
    NSNetService *service;
    GCDAsyncSocket *serverSocket;
    GCDAsyncSocket *clientSocket;
}

- (void)powerService:(BOOL)power;

@end

@implementation OPLHumanAI
// ================================================================
#pragma mark - Properties
// ================================================================
// delegate is being auto-synthesized, means don't worry about it, compiler's got it.

// ================================================================
#pragma mark - Public Methods
// ================================================================
- (void)powerService:(BOOL)power {
    [serverSocket setIPv4Enabled:power];
    [serverSocket setIPv6Enabled:power];

    if (power) [service publish]; // if powered, show it to the world!!!
    else [service stop]; // Or not, same deal
}

- (void)respondToMessage:(NSString *)message {
//    if (!clientSocket)
//        [self.delegate humanAI:self didRespondWithMessage:@"Don't bother me."];

    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableData *outboundData = [NSMutableData dataWithData:messageData];

    [outboundData appendData:[GCDAsyncSocket CRLFData]];

    [clientSocket writeData:outboundData
                withTimeout:OPL_HUMANAI_SOCKET_NO_TIMEOUT
                        tag:0];
}


// ================================================================
#pragma mark - Net Service Delegate
// ================================================================
- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"Published service");
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    NSAlert *noPublish = [NSAlert alertWithMessageText:@"Unable to start net service! \nRestart application!"
                                         defaultButton:@"I guess..."
                                       alternateButton:NULL
                                           otherButton:NULL
                             informativeTextWithFormat:NULL];
    [noPublish runModal];
}

- (void)netServiceDidStop:(NSNetService *)sender {
    NSLog(@"Stopped service");
}


// ================================================================
#pragma mark - Socket Delegate
// ================================================================
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    // If the server socket accepted a new socket, then it must be the client socket.
    if (serverSocket != sock || clientSocket != NULL) return;

    // Once client is enough
    [self powerService:NO];

    clientSocket = newSocket;

#if DEBUG
    NSLog(@"Connected!!!");
#endif

    // To begin reading data
    [clientSocket readDataToData:[GCDAsyncSocket CRLFData]
                     withTimeout:OPL_HUMANAI_SOCKET_NO_TIMEOUT
                             tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if (clientSocket != sock) return;

    clientSocket = NULL;        // Trash the socket
    [self powerService:YES];    // Publish again
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // We only care about the client!!! Better than Electronic Arts (EA and BF4)...
    if (clientSocket != sock) return;

    NSString *message = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];

    [self.delegate humanAI:self didRespondWithMessage:message];

    // To continue reading data, this is basically a loop.
    [clientSocket readDataToData:[GCDAsyncSocket CRLFData]
                     withTimeout:OPL_HUMANAI_SOCKET_NO_TIMEOUT
                             tag:0];
}


// ================================================================
#pragma mark - Initializers
// ================================================================
- (instancetype)initWithDelegate:(id<OPLHumanAIDelegate>)delegate {
    if (!(self = [self init])) return NULL;
    _delegate = delegate;
    return self;
}

- (instancetype)init {
    if (!(self = [super init])) {
        NSLog(@"Something went terribly wrong!!! WTF!? DX<");
        return NULL;
    }

    // Prepare asynchronous socket
    serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_main_queue()];


    // Prepare net service descriptor
    NSString *computerName = [[NSHost currentHost] localizedName];
    service = [[NSNetService alloc] initWithDomain:@"local."
                                              type:OPL_HUMANAI_SOCKET_SERVICE
                                              name:computerName
                                              port:OPL_HUMANAI_SOCKET_PORT];

    [service setDelegate:self];


    // Begin accepting on the given address and port
    if (![serverSocket acceptOnPort:OPL_HUMANAI_SOCKET_PORT error:nil]) {
        NSLog(@"Unable to start server socket!");
    }


    [self powerService:YES];

    return self;
}
@end
