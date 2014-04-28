//
//  OPLDatabaseFile.m
//  Morpheus
//
//  Created by Matias Barcenas on 4/28/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import "OPLDatabaseFile.h"

@interface OPLDatabaseFile () {
    NSFileManager *fileManager;
    NSArray *keys;
    NSArray *unknown;
}

@end


@implementation OPLDatabaseFile

- (NSString *)answerForQuery:(NSString *)message {
    if ([keys containsObject:[message lowercaseString]]) {
        return [self.data objectForKey:[message lowercaseString]];
    }

    return [unknown objectAtIndex: (arc4random() % [unknown count])];
}

- (instancetype)init {
    if (!(self = [super init])) return NULL;

    fileManager = [NSFileManager new];

    NSMutableString *filePath = [NSMutableString new];
    [filePath appendString:NSHomeDirectory()];
    [filePath appendFormat:@"/Desktop/%@", OPL_COMPUTERAI_DATABASE];

    if ([fileManager fileExistsAtPath:filePath]) {
        NSURL *path = [NSURL fileURLWithPath:filePath];
        NSData *contents = [NSData dataWithContentsOfURL:path];
        id object = [NSJSONSerialization JSONObjectWithData:contents
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
        if ([object isKindOfClass:[NSDictionary class]]) {
            _data = object;
        }
    }

    // Backup
    if (!_data) {
        _data = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"Morpheus", @"what's your name?",
                 @"None of your business.", @"where were you born?",
                 @"Last night.", @"when were you compiled?",
                 nil];
    }

    keys = [_data allKeys];

    unknown = @[
                @"I don't know.",
                @"I'm bored.",
                @"Leave me alone already."
                ];

    return self;
}
@end
