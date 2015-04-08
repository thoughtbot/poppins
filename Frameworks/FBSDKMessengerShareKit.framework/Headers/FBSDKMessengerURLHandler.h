// Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>

@class FBSDKMessengerURLHandler,
FBSDKMessengerURLHandlerReplyContext,
FBSDKMessengerURLHandlerOpenFromComposerContext,
FBSDKMessengerURLHandlerCancelContext;

@protocol FBSDKMessengerURLHandlerDelegate <NSObject>

@optional

/*!
 @abstract
 This is called after FBSDKMessengerURLHandler has received a reply from messenger

 @param messengerURLHandler The handler that handled the URL
 @param context The data passed from Messenger
 */
- (void)messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
  didHandleReplyWithContext:(FBSDKMessengerURLHandlerReplyContext *)context;

/*!
 @abstract
 This is called after a user tapped this app from the composer in Messenger

 @param messengerURLHandler The handler that handled the URL
 @param context The data passed from Messenger
 */
- (void)          messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
 didHandleOpenFromComposerWithContext:(FBSDKMessengerURLHandlerOpenFromComposerContext *)context;

/*!
 @abstract
 This is called after a user canceled a share and Messenger redirected here

 @param messengerURLHandler The handler that handled the URL
 @param context The data passed from Messenger
 */
- (void)messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
 didHandleCancelWithContext:(FBSDKMessengerURLHandlerCancelContext *)context;

@end

/*!
 @class FBSDKMessengerURLHandler

 @abstract
 FBSDKMessengerURLHandler is used to handle incoming URLs from Messenger.
 */
@interface FBSDKMessengerURLHandler : NSObject

/*!
  @abstract
  Determines whether an incoming URL can be handled by this class

  @param url The URL passed in from the source application
  @param sourceApplication The bundle id representing the source application

  @return YES if this URL can be handled
 */
- (BOOL)canOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

/*!
  @abstract
  Attempts to handle the Messenger URL and returns YES if and only if successful.
  This should be called from the AppDelegate's -openURL: method

  @param url The URL passed in from the source application
  @param sourceApplication The bundle id representing the source application

   @return YES if this successfully handled the URL
 */
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

@property (nonatomic, weak) id<FBSDKMessengerURLHandlerDelegate> delegate;

@end
