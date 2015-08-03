//
//  Hound.h
//  HoundSDK
//
//  Created by Cyril Austin on 5/20/15.
//  Copyright (c) 2015 SoundHound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Hound

@interface Hound : NSObject

+ (NSString*)SDKVersion;

+ (void)setClientID:(NSString*)clientID;
+ (void)setClientKey:(NSString*)clientKey;

+ (void)resetConversationState;


@end
