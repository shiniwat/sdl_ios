//
//  SDLHapticManagerSpec.m
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLHapticManager.h"
#import "SDLSendHapticData.h"
#import "SDLManager.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouch.h"
#import "SDLRectangle.h"
#import "SDLLifecycleManager.h"

SDLTouch* generateTouchEvent(int xCoord, int yCoord)
{
    unsigned long timeStamp = 10;
    SDLTouchCoord* firstCoord = [[SDLTouchCoord alloc] init];
    firstCoord.x = @(xCoord);
    firstCoord.y = @(yCoord);
    
    SDLTouchEvent* firstTouchEvent = [[SDLTouchEvent alloc] init];
    firstTouchEvent.touchEventId = @0;
    firstTouchEvent.coord = [NSArray arrayWithObject:firstCoord];
    firstTouchEvent.timeStamp = [NSMutableArray arrayWithObject:@(timeStamp)];
    SDLTouch* firstTouch = [[SDLTouch alloc] initWithTouchEvent:firstTouchEvent];
    return firstTouch;
}

BOOL compareRectangle(SDLRectangle *sdlRectangle, CGRect cgRect)
{
    expect(sdlRectangle.x).to(equal(cgRect.origin.x));
    expect(sdlRectangle.y).to(equal(cgRect.origin.y));
    expect(sdlRectangle.width).to(equal(cgRect.size.width));
    expect(sdlRectangle.height).to(equal(cgRect.size.height));
    return YES;
}

QuickSpecBegin(SDLHapticManagerSpec)

describe(@"the haptic manager", ^{
    __block UIWindow *uiWindow;
    __block UIViewController *uiViewController;
    
    __block SDLHapticManager *hapticManager;
    __block SDLSendHapticData* sentHapticRequest;
    
    __block id sdlLifecycleManager = OCMClassMock([SDLLifecycleManager class]);
    __block CGRect viewRect1;
    __block CGRect viewRect2;
    
    beforeEach(^{
        hapticManager = nil;
        sentHapticRequest = nil;
        
        uiWindow = [[UIWindow alloc] init];
        uiViewController = [[UIViewController alloc] init];
        
        [uiWindow addSubview:uiViewController.view];
        
        OCMExpect( [[sdlLifecycleManager stub] sendManagerRequest:[OCMArg checkWithBlock:^BOOL(id value){
            BOOL isFirstArg = [value isKindOfClass:[SDLSendHapticData class]];
            if(isFirstArg) {
                sentHapticRequest = value;
            }
            return YES;
        }]  withResponseHandler:[OCMArg any]]);

    });
    
    context(@"when initialized with no focusable view", ^{
        beforeEach(^{
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have no focusable view", ^{
            OCMVerify(sdlLifecycleManager);
            expect(sentHapticRequest.hapticRectData.count).to(equal(0));
        });
    });
    
    context(@"when initialized with single view", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiWindow insertSubview:textField1 aboveSubview:uiWindow];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have one view", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;
                
                compareRectangle(sdlRect, viewRect1);
            }
        });
    });
    
    context(@"when initialized with single button view", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UIButton *button = [[UIButton alloc]  initWithFrame:viewRect1];
            [uiWindow addSubview:button];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have one view", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;
                
                compareRectangle(sdlRect, viewRect1);
            }
        });
    });
    
    context(@"when initialized with no views and then updated with two additional views", ^{
        beforeEach(^{
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
            
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];
            
            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];
            
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have two views", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;
                
                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;
                
                compareRectangle(sdlRect1, viewRect1);
                compareRectangle(sdlRect2, viewRect2);
            }
        });
    });
    
    context(@"when initialized with nested views", ^{
        beforeEach(^{
            UITextField *textField = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField];
            
            viewRect1 = CGRectMake(110, 110, 10, 10);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [textField addSubview:textField1];
            
            viewRect2 = CGRectMake(130, 130, 10, 10);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [textField addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have only leaf views added", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;
                
                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;
                
                compareRectangle(sdlRect1, viewRect1);
                compareRectangle(sdlRect2, viewRect2);
            }
        });
    });
    
    context(@"when initialized with nested button views", ^{
        beforeEach(^{
            UIButton *button = [[UIButton alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:button];
            
            viewRect1 = CGRectMake(110, 110, 10, 10);
            UIButton *button1 = [[UIButton alloc]  initWithFrame:viewRect1];
            [button addSubview:button1];
            
            viewRect2 = CGRectMake(130, 130, 10, 10);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [button addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have only leaf views added", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;
                
                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;
                
                compareRectangle(sdlRect1, viewRect1);
                compareRectangle(sdlRect2, viewRect2);
            }
        });
    });
    
    context(@"when initialized with two views and then updated with one view removed", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];
            
            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
            
            [textField2 removeFromSuperview];
            
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should have one view", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 1;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect = hapticRectData[0];
                SDLRectangle *sdlRect = sdlhapticRect.rect;
                
                compareRectangle(sdlRect, viewRect1);
            }
        });
    });

    context(@"when initialized with one view and notified after adding one more view", ^{
        beforeEach(^{
            viewRect1 = CGRectMake(101, 101, 50, 50);
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:viewRect1];
            [uiViewController.view addSubview:textField1];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
            
            viewRect2 = CGRectMake(201, 201, 50, 50);
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:viewRect2];
            [uiViewController.view addSubview:textField2];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidUpdateProjectionView object:nil];
        });
        
        it(@"should have two views", ^{
            OCMVerify(sdlLifecycleManager);
            
            int expectedCount = 2;
            expect(sentHapticRequest.hapticRectData.count).to(equal(expectedCount));
            
            if(sentHapticRequest.hapticRectData.count == expectedCount) {
                NSArray<SDLHapticRect *> *hapticRectData = sentHapticRequest.hapticRectData;
                SDLHapticRect *sdlhapticRect1 = hapticRectData[0];
                SDLRectangle *sdlRect1 = sdlhapticRect1.rect;
                
                SDLHapticRect *sdlhapticRect2 = hapticRectData[1];
                SDLRectangle *sdlRect2 = sdlhapticRect2.rect;
                
                compareRectangle(sdlRect1, viewRect1);
                compareRectangle(sdlRect2, viewRect2);
            }
        });
    });
    
    context(@"when touched inside a view", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(201, 201, 50, 50)];
            [uiViewController.view addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should return a view object", ^{
            SDLTouch* collisionTouch1 = generateTouchEvent(125, 120);
            UIView* view1 = [hapticManager viewForSDLTouch:collisionTouch1];
            
            expect(view1).toNot(beNil());
            
            SDLTouch* collisionTouch2 = generateTouchEvent(202, 249);
            UIView* view2 = [hapticManager viewForSDLTouch:collisionTouch2];
            
            expect(view2).toNot(beNil());
        });
    });
    
    context(@"when touched in overlapping views' area", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiViewController.view addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc]  initWithFrame:CGRectMake(126, 126, 50, 50)];
            [uiViewController.view addSubview:textField2];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        
        it(@"should return no view object", ^{
            SDLTouch* collisionTouch = generateTouchEvent(130, 130);
            UIView* view = [hapticManager viewForSDLTouch:collisionTouch];
            
            expect(view).to(beNil());
        });
    });
    
    context(@"when touched outside view boundary", ^{
        beforeEach(^{
            UITextField *textField1 = [[UITextField alloc]  initWithFrame:CGRectMake(101, 101, 50, 50)];
            [uiWindow insertSubview:textField1 aboveSubview:uiWindow];
            
            hapticManager = [[SDLHapticManager alloc] initWithWindow:uiWindow  connectionManager:sdlLifecycleManager];
            [hapticManager updateInterfaceLayout];
        });
        it(@"should return nil", ^{
            SDLTouch* collisionTouch = generateTouchEvent(0, 228);
            UIView* view = [hapticManager viewForSDLTouch:collisionTouch];
            expect(view).to(beNil());
        });
        
    });
});

QuickSpecEnd
