//
//  OPLComputerAI.h
//  Morpheus
//
//  Created by Matias Barcenas on 4/27/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPLHumanAI.h"
#import "OPLDatabaseFile.h"

#define OPL_COMPUTERAI_PRESPONSE_TIMEOUT    5.0

@protocol OPLComputerAIDelegate; // To let the compiler know the protocol exists

// ================================================================
@interface OPLComputerAI : NSObject
// ================================================================

// Properties
@property (nonatomic, weak) id<OPLComputerAIDelegate>delegate;


// Methods
- (void)respondToMessage:(NSString *)message;

// Initializers
- (instancetype)initWithDelegate:(id<OPLComputerAIDelegate>)delegate;
- (instancetype)init;

@end


// ================================================================
@protocol OPLComputerAIDelegate <NSObject>
// ================================================================
@required
- (void)computerAI:(OPLComputerAI *)computerAI didRespondWithMessage:(NSString *)message;
@end
