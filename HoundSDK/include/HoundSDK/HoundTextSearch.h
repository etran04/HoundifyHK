//
//  HoundTextSearch.h
//  HoundSDK
//
//  Created by Cyril Austin on 5/20/15.
//  Copyright (c) 2015 SoundHound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Callbacks

typedef void (^HoundTextSearchCallback)(NSError* error, NSString* query, NSDictionary* houndServer);

#pragma mark - HoundTextSearch

@interface HoundTextSearch : NSObject

+ (instancetype)instance;

- (void)searchWithQuery:(NSString*)query
    requestInfo:(NSDictionary*)requestInfo
    userID:(NSString*)userID
    endPointURL:(NSURL*)endPointURL
    completionHandler:(HoundTextSearchCallback)handler;

@end
