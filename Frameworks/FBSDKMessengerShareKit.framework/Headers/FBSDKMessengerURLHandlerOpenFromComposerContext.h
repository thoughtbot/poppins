//  Copyright 2004-present Facebook. All Rights Reserved.

#import "FBSDKMessengerShareKit.h"

/*!
 @class FBSDKMessengerURLHandlerReplyContext

 @abstract
 This object represents a user selecting this app from the composer in Messenger
 Passing this context into a share method will trigger a the reply flow
 */
@interface FBSDKMessengerURLHandlerOpenFromComposerContext : FBSDKMessengerContext

/*!
 @abstract
 Additional information that was passed along with the original media

 @discussion
 Note that when opening your app from Messenger composer, the metadata is pulled from
 the most recent attributed message on the thread.
 If the most recent attributed message with metadata is not cached on the device, metadata will be nil
 */
@property (nonatomic, copy, readonly) NSString *metadata;

/*!
 @abstract
 The user IDs of the other participants on the thread.

 @discussion
 User IDs can be used with the Facebook SDK and Graph API (https://developers.facebook.com/docs/graph-api)
 to query names, photos, and other data. This will only contain IDs of users that
 have also logged into your app via their Facebook account.

 Note that when opening your app from Messenger composer, the userIDs are pulled from
 the most recent attributed message on the thread.
 If the most recent attributed message is not cached on the device, userIDs will be nil
 */
@property (nonatomic, copy, readonly) NSSet *userIDs;

@end
