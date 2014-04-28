//
//  OPLDatabaseFile.h
//  Morpheus
//
//  Created by Matias Barcenas on 4/28/14.
//  Copyright (c) 2014 Organization of Programming Languages. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OPL_COMPUTERAI_DATABASE             @"Morpheus.json"

@interface OPLDatabaseFile : NSObject
@property (nonatomic, strong, readonly) NSDictionary *data;
- (NSString *)answerForQuery:(NSString *)message;

- (instancetype)init;
@end
