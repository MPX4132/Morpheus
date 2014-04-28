//
//  OPLHumanAI.h
//  Morpheus
//
//  Created by Matias Barcenas on 4/27/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

//  Notice: Everything in this file is public to anyone!


#define OPL_HUMANAI_SOCKET_NO_TIMEOUT   -1
#define OPL_HUMANAI_SOCKET_PORT         64132
#define OPL_HUMANAI_SOCKET_SERVICE      @"_morpheus._tcp."

@protocol OPLHumanAIDelegate; // To let the compiler know it exsists

// ================================================================
@interface OPLHumanAI : NSObject <NSNetServiceDelegate>
// ================================================================

// Properties
@property (nonatomic, weak) id<OPLHumanAIDelegate>delegate;


// Methods
- (void)respondToMessage:(NSString *)message;

// Initializers
- (instancetype)initWithDelegate:(id<OPLHumanAIDelegate>)delegate;
- (instancetype)init;

@end


// ================================================================
@protocol OPLHumanAIDelegate <NSObject>
// ================================================================
@required
- (void)humanAI:(OPLHumanAI *)humanAI didRespondWithMessage:(NSString *)message;

@optional
- (void)humanAIDied:(OPLHumanAI *)humanAI;
@end
