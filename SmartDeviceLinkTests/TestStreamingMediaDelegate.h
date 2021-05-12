//
//  TestStreamingMediaDelegate.h
//  SmartDeviceLinkTests
//
//  Created by Leonid Lokhmatov on 8/24/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import "SDLStreamingVideoDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestStreamingMediaDelegate : NSObject <SDLStreamingVideoDelegate>
@property (nonatomic, readonly) NSArray *recordedSizes;
@property (nonatomic, assign) BOOL isStopped;
- (void)reset;
@end

NS_ASSUME_NONNULL_END
