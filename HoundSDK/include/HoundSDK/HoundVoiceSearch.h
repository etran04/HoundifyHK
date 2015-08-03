//
//  HoundVoiceSearch.h
//  HoundSDK
//
//  Created by Cyril Austin on 5/20/15.
//  Copyright (c) 2015 SoundHound, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Notifications

extern NSString* HoundVoiceSearchStateChangeNotification;
extern NSString* HoundVoiceSearchAudioLevelNotification;

#pragma mark - HoundVoiceSearchResponseType

typedef NS_ENUM(NSUInteger, HoundVoiceSearchResponseType)
{
    HoundVoiceSearchResponseTypeNone,
    HoundVoiceSearchResponseTypePartialTranscription,
    HoundVoiceSearchResponseTypeHoundServer
};

#pragma mark - Errors

extern NSString* HoundVoiceSearchErrorDomain;

typedef NS_ENUM(NSUInteger, HoundVoiceSearchErrorCode)
{
    HoundVoiceSearchErrorCodeCancelled,
    HoundVoiceSearchErrorCodeNotReady,
    HoundVoiceSearchErrorCodeNoResponseReceived,
    HoundVoiceSearchErrorCodeInvalidResponse,
    HoundVoiceSearchErrorCodeAudioInterrupted,
    HoundVoiceSearchErrorCodeParseFailed,
};

#pragma mark - HoundVoiceSearchState

typedef NS_ENUM(NSUInteger, HoundVoiceSearchState)
{
    HoundVoiceSearchStateNone,
    HoundVoiceSearchStateReady,
    HoundVoiceSearchStateRecording,
    HoundVoiceSearchStateSearching,
    HoundVoiceSearchStateSpeaking
};

#pragma mark - Callbacks

typedef void (^HoundVoiceSearchErrorCallback)(NSError* error);
typedef void (^HoundVoiceSearchResponseCallback)(NSError* error,
    HoundVoiceSearchResponseType responseType, NSDictionary* response);

#pragma mark - HoundVoiceSearch

@interface HoundVoiceSearch : NSObject

@property(nonatomic, assign, readonly) HoundVoiceSearchState state;

@property(atomic, assign) BOOL enableEndOfSpeechDetection;
@property(atomic, assign) BOOL enableSpeech;

+ (instancetype)instance;

// Automatic search methods

- (void)startListeningWithCompletionHandler:(HoundVoiceSearchErrorCallback)handler;
- (void)stopListeningWithCompletionHandler:(HoundVoiceSearchErrorCallback)handler;

- (void)startSearchWithRequestInfo:(NSDictionary*)requestInfo
    userID:(NSString*)userID
    endPointURL:(NSURL*)endPointURL
    responseHandler:(HoundVoiceSearchResponseCallback)responseHandler;

// Raw audio search methods

- (void)startRawAudioSearchWithRequestInfo:(NSDictionary*)requestInfo
    userID:(NSString*)userID
    endPointURL:(NSURL*)endPointURL
    audioSampleRate:(double)audioSampleRate
    responseHandler:(HoundVoiceSearchResponseCallback)responseHandler;

- (void)writeRawAudioData:(NSData*)data;

// General methods

- (void)stopSearch;
- (void)cancelSearch;

- (void)stopSpeaking;

@end