//  Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FBSDKMessengerContext;
@class FBSDKMessengerShareOptions;

/*!
 @typedef NS_OPTION(NSUInteger, FBSDKMessengerPlatformCapability)
 @abstract Used to test the platform capabilities the currently installed Messenger version has
 */
typedef NS_OPTIONS(NSUInteger, FBSDKMessengerPlatformCapability)
{
  FBSDKMessengerPlatformCapabilityNone         = 0,
  FBSDKMessengerPlatformCapabilityOpen         = 1 << 0,
  FBSDKMessengerPlatformCapabilityImage        = 1 << 1,
  FBSDKMessengerPlatformCapabilityAnimatedGIF  = 1 << 2,
  FBSDKMessengerPlatformCapabilityAnimatedWebP = 1 << 3,
  FBSDKMessengerPlatformCapabilityVideo        = 1 << 4,
  FBSDKMessengerPlatformCapabilityAudio        = 1 << 5,
};

/*!
 @class FBSDKMessengerSharer

 @abstract
 The FBSDKMessengerSharer is used to share media from apps into Messenger. The underlying
 mechanism used to share data between apps is UIPasteboard

 @discussion
 - FacebookAppID must be set in the your app's Info.plist with the Facebook App Id
 - Any existing data in the system's public pasteboard will get overwritten with the shared media
 - Once the data is shared in Messenger, the pasteboard with be cleared
 - The following strings need to be translated in your app:
    NSLocalizedString(@"Get Messenger", @"Alert title telling a user they need to install Messenger")
    NSLocalizedString(@"You'll need to install the latest version of Messenger to send this.", @"Alert message when an old version of messenger is installed")
    NSLocalizedString(@"Not Now", @"Button label when user doesn't want to install Messenger")
    NSLocalizedString(@"Install", @"Button label to install Messenger")
    NSLocalizedString(@"Send", @"Button label for sending a message")
 */
@interface FBSDKMessengerSharer : NSObject

/*!
 @abstract
 This method checks the currently installed version of Messenger to see what SDK capabilities it has

 @discussion
 Before sharing any media, first use this bitmask to check to see if it can be shared to Messenger

 @return bitmask of the Messenger capabilities
 */
+ (FBSDKMessengerPlatformCapability)messengerPlatformCapabilities;

/*!
 @abstract
 Call this method to open Messenger
 */
+ (void)openMessenger;

/*!
 @abstract
 Call this method to open Messenger and share an image.

 @deprecated
 use shareImage:withOptions: instead

 @param image The image to be shared in Messenger
 @param metadata Additional optional information to be sent to Messenger which is sent back to
 the user's app when they reply to an attributed message. This may be nil.
 @param context The way the content is to be shared in Messenger. If nil, a standard share will take place.

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareImage:(UIImage *)image
      withMetadata:(NSString *)metadata
       withContext:(FBSDKMessengerContext *)context __attribute__ ((deprecated("use use shareImage:withOptions: instead")));

/*!
 @abstract
 Call this method to open Messenger and share an image.

 @param image The image to be shared in Messenger
 @param options Additional optional parameters that affect the way the content is shared

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareImage:(UIImage *)image withOptions:(FBSDKMessengerShareOptions *)options;

/*!
 @abstract
 Call this method to open Messenger and share an animated GIF.

 @deprecated
 use shareAnimatedGIF:withOptions: instead

 @param animatedGIFData The animated GIF to be shared in Messenger
 @param metadata Additional optional information to be sent to Messenger which is sent back to
 the user's app when they reply to an attributed message. This may be nil.
 @param context The way the content is to be shared in Messenger. If nil, a standard share will take place.

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareAnimatedGIF:(NSData *)animatedGIFData
            withMetadata:(NSString *)metadata
             withContext:(FBSDKMessengerContext *)context __attribute__ ((deprecated("use use shareAnimatedGIF:withOptions: instead")));

/*!
 @abstract
 Call this method to open Messenger and share an animated GIF.

 @param animatedGIFData The animated GIF to be shared in Messenger
 @param options Additional optional parameters that affect the way the content is shared

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareAnimatedGIF:(NSData *)animatedGIFData withOptions:(FBSDKMessengerShareOptions *)options;

/*!
 @abstract
 Call this method to open Messenger and share an animated GIF.

 @deprecated
 use shareAnimatedWebP:withOptions: instead

 @param animatedWebPData The animated WebP image to be shared in Messenger
 @param metadata Additional optional information to be sent to Messenger which is sent back to
 the user's app when they reply to an attributed message. This may be nil.
 @param context The way the content is to be shared in Messenger. If nil, a standard share will take place.

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareAnimatedWebP:(NSData *)animatedWebPData
             withMetadata:(NSString *)metadata
              withContext:(FBSDKMessengerContext *)context __attribute__ ((deprecated("use use shareAnimatedWebP:withOptions: instead")));

/*!
 @abstract
 Call this method to open Messenger and share an animated GIF.

 @param animatedWebPData The animated WebP image to be shared in Messenger
 @param options Additional optional parameters that affect the way the content is shared

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareAnimatedWebP:(NSData *)animatedWebPData withOptions:(FBSDKMessengerShareOptions *)options;

/*!
 @abstract
 Call this method to open Messenger and share a video.

 @deprecated
 use shareVideo:withOptions: instead

 @discussion
 Note that there's no way to send an AVAsset between apps, so you may need to
 serialize your AVAsset to a file, and get an NSData representation of the video via
 [NSData dataWithContentsOfFile:filepath];

 @param videoData The image to be shared in Messenger
 @param metadata Additional optional information to be sent to Messenger which is sent back to
 the user's app when they reply to an attributed message. This may be nil.
 @param context The way the content is to be shared in Messenger. If nil, a standard share will take place.

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareVideo:(NSData *)videoData
      withMetadata:(NSString *)metadata
       withContext:(FBSDKMessengerContext *)context __attribute__ ((deprecated("use use shareVideo:withOptions: instead")));

/*!
 @abstract
 Call this method to open Messenger and share a video.

 @discussion
 Note that there's no way to send an AVAsset between apps, so you may need to
 serialize your AVAsset to a file, and get an NSData representation of the video via
 [NSData dataWithContentsOfFile:filepath];

 @param videoData The image to be shared in Messenger
 @param options Additional optional parameters that affect the way the content is shared

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareVideo:(NSData *)videoData withOptions:(FBSDKMessengerShareOptions *)options;

/*!
 @abstract
 Call this method to open Messenger and share an audio file.

 @deprecated
 use shareAudio:withOptions: instead

 @discussion
 Note that there's no way to send an AVAsset between apps, so you may need to
 serialize your AVAsset to a file, and get an NSData representation of the video via
 [NSData dataWithContentsOfFile:filepath];

 @param audioData The audio to be shared in Messenger
 @param metadata Additional optional information to be sent to Messenger

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
*/
+ (void)shareAudio:(NSData *)audioData
      withMetadata:(NSString *)metadata
       withContext:(FBSDKMessengerContext *)context __attribute__ ((deprecated("use use shareAudio:withOptions: instead")));

/*!
 @abstract
 Call this method to open Messenger and share an audio file.

 @discussion
 Note that there's no way to send an AVAsset between apps, so you may need to
 serialize your AVAsset to a file, and get an NSData representation of the video via
 [NSData dataWithContentsOfFile:filepath];

 @param audioData The audio to be shared in Messenger
 @param options Additional optional parameters that affect the way the content is shared

 @discussion If there is not an installed version of Messenger on the device that supports the share, an alert will be presented to the user to go to the App Store to install the latest version of Messenger
 */
+ (void)shareAudio:(NSData *)audioData withOptions:(FBSDKMessengerShareOptions *)options;

@end
