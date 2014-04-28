//
//  OPLAppController.m
//  Morpheus
//
//  Created by Matias Barcenas on 4/28/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import "OPLAppController.h"

@interface OPLAppController () {
    NSSpeechSynthesizer *voice;
    OPLComputerAI *computer;
}

@property (weak) IBOutlet NSTextField *inputField;
@property (weak) IBOutlet NSTextField *outputField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *sendButton;


- (void)startThinking;
- (void)stopThinking;

@end

@implementation OPLAppController
- (IBAction)send:(id)sender {
    [self startThinking];
}


- (void)startThinking {
    // Hide the send button
    [self.sendButton setHidden:YES];

    // Block input to the input box
    [self.inputField setEditable:NO];
    [self.inputField setSelectable:NO];

    // Show thinking indicator
    [self.progressIndicator startAnimation:self];

    // Pass the message to the AI
    [computer respondToMessage:[self.inputField stringValue]];
}

- (void)stopThinking {
    // Stop the thinking indicator
    [self.progressIndicator stopAnimation:self];

    // Hide the send button
    [self.sendButton setHidden:NO];

    // Clear the user input
    [self.inputField setStringValue:@""];

    // Allow for user input
    [self.inputField setEditable:YES];
    [self.inputField setSelectable:YES];
}


// ================================================================
#pragma mark - HumanAI Delegate
// ================================================================
- (void)computerAI:(OPLComputerAI *)computerAI didRespondWithMessage:(NSString *)message {
    // To "Reset" interface
    [self stopThinking];

    // Set the response message
    [self.outputField setStringValue:message];

    // Speak string, this is unsafe since it's not checking for alpha
    [voice startSpeakingString:message];
}


// ================================================================
#pragma mark - Initializer
// ================================================================
- (instancetype)init
{
    if (!(self = [super init])) {
        NSLog(@"Something went terribly wrong! OMG!");
        return NULL;
    }

    voice = [NSSpeechSynthesizer new];
    computer = [[OPLComputerAI alloc] initWithDelegate:self];

    return self;
}

@end
