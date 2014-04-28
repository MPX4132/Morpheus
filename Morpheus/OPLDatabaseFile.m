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
    if ([keys containsObject:message]) {
        return [self.data objectForKey:message];
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
                 @"what's your name?", @"Morpheus",
                 @"where were you born?", @"None of your business.",
                 @"when were you compiled?", @"Last night.",
                 nil];
    }

    keys = [_data allKeys];

    unknown = @[
                @"I don't know.",
                @"I'm bored.",
                @"Lave me alone already."
                ];

    return self;
}
@end
