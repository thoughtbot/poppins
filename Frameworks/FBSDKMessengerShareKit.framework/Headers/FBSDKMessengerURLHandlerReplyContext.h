//  Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>

#import "FBSDKMessengerContext.h"

/*!
 @class FBSDKMessengerURLHandlerReplyContext

 @abstract
 This object represents a user tapping reply from a message in Messenger. Passing
 this context into a share method will trigger the reply flow
 */
@interface FBSDKMessengerURLHandlerReplyContext : FBSDKMessengerContext

/*!
 @abstract
 Additional information that was passed along with the original media that was replied to

 @discussion
 If content shared to Messenger incuded metadata and the user replied to that message,
 that metadata is passed along with the reply back to the app. If no metadata was included
 this is nil
 */
@property (nonatomic, copy, readonly) NSString *metadata;

/*!
 @abstract
 The user IDs of the other participants on the thread.

 @discussion
 User IDs can be used with the Facebook SDK and Graph API (https://developers.facebook.com/docs/graph-api)
 to query names, photos, and other data. This will only contain IDs of users that
 have also logged into your app via their Facebook account.
 */
@property (nonatomic, copy, readonly) NSSet *userIDs;

@end
