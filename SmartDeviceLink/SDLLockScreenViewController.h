//
//  SDLLockScreenViewController.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenViewController : UIViewController

typedef void (^SwipeGestureCallbackBlock)(void);

/**
 *  The app's icon. This will be set by the lock screen configuration.
 */
@property (copy, nonatomic, nullable) UIImage *appIcon;

/**
 *  The vehicle's designated icon. This will be set by the lock screen manager when it is notified that a lock screen icon has been downloaded.
 */
@property (copy, nonatomic, nullable) UIImage *vehicleIcon;

/**
 *  The designated background color set in the lock screen configuration, or the default SDL gray-blue.
 */
@property (copy, nonatomic, nullable) UIColor *backgroundColor;

/**
 *  The locked label string. This will be set by the lock screen manager to inform the user about the dismissable state.
 */
@property (copy, nonatomic, nullable) NSString *lockedLabelText;

/**
 *  Adds a swipe gesture to the lock screen view controller.
 */
- (void)addDismissGestureWithCallback:(SwipeGestureCallbackBlock)swipeGestureCallback;

/**
 *  Remove swipe gesture to the lock screen view controller.
 */
- (void)removeDismissGesture;

@end

NS_ASSUME_NONNULL_END
