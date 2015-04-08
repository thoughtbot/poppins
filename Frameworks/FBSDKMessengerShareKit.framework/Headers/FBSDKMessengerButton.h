#import <UIKit/UIKit.h>

/*!
 @abstract
 Defines what visual style a UIButton should have
 */
typedef NS_ENUM(NSUInteger, FBSDKMessengerShareButtonStyle) {
  FBSDKMessengerShareButtonStyleBlue = 0,
  FBSDKMessengerShareButtonStyleWhite = 1,
  FBSDKMessengerShareButtonStyleWhiteBordered = 2,
};

/*!
 @class FBSDKMessengerShareButton

 @abstract
 Provides a helper method to return a UIButton intended for sharing to Messenger
 */
@interface FBSDKMessengerShareButton : NSObject

/*!
 @abstract
 Returns a rounded rectangular UIButton customized for sharing to Messenger

 @param style Specifies how the button should look

 @discussion
 This button can be resized after creation

 There is 1 string in the implemention of this button which needs to be translated
 by your app:

 NSLocalizedString(@"Send", @"Button label for sending a message")
 */
+ (UIButton *)rectangularButtonWithStyle:(FBSDKMessengerShareButtonStyle)style;


/*!
 @abstract
 Returns a circular UIButton customized for sharing to Messenger

 @param style Specifies how the button should look
 @param width The desired frame width (and height) of this button.

 @discussion
 This button's asset is drawn as a vector such that it scales appropriately
 using the width parameter as a hint. This hint is to prevent button resizing artifacts.
 */
+ (UIButton *)circularButtonWithStyle:(FBSDKMessengerShareButtonStyle)style
                                width:(CGFloat)width;

/*!
 @abstract
 Returns a circular UIButton customized for sharing to Messenger of default size

 @param style Specifies how the button should look
 */
+ (UIButton *)circularButtonWithStyle:(FBSDKMessengerShareButtonStyle)style;

@end
