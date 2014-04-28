//
//  OPLComputerAI.m
//  Morpheus
//
//  Created by Matias Barcenas on 4/27/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import "OPLComputerAI.h"

@interface OPLComputerAI()<OPLHumanAIDelegate> {
    OPLHumanAI  *human;
    NSTimer     *responseTimer;
    NSString    *query;
}

- (void)computerResponse;

@end

@implementation OPLComputerAI
// ================================================================
#pragma mark - Properties
// ================================================================
// delegate is being auto-synthesized, means don't worry about it, compiler's got it.

// ================================================================
#pragma mark - Public Methods
// ================================================================
- (void)respondToMessage:(NSString *)message {
    responseTimer = [NSTimer timerWithTimeInterval:OPL_COMPUTERAI_PRESPONSE_TIMEOUT
                                            target:self
                                          selector:@selector(computerResponse)
                                          userInfo:nil
                                           repeats:NO];

    [human respondToMessage:(query = message)];

    [responseTimer fire];
}

- (void)computerResponse {
    NSLog(@"I'll respond now!");
}

// ================================================================
#pragma mark - HumanAI Delegate
// ================================================================
- (void)humanAI:(OPLHumanAI *)humanAI didRespondWithMessage:(NSString *)message {
    if (responseTimer) [responseTimer invalidate];

    [self.delegate computerAI:self didRespondWithMessage:message];
}

//- (void)humanAIDied:(OPLHumanAI *)humanAI {
//
//}


// ================================================================
#pragma mark - Initializers
// ================================================================
- (instancetype)initWithDelegate:(id<OPLComputerAIDelegate>)delegate {
    if (!(self = [self init])) return NULL;
    _delegate = delegate;
    return self;
}

- (instancetype)init {
    if (!(self = [super init])) {
        NSLog(@"Something went wrong!!! OMGEE!!!");
        return NULL;
    }



    return self;
}

@end
