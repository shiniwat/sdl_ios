//
//  SDLSyncMsgVersionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSyncMsgVersion.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLSyncMsgVersionSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];

        testStruct.majorVersion = @4;
        testStruct.minorVersion = @532;
        testStruct.patchVersion = @12;

        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
        expect(testStruct.patchVersion).to(equal(@12));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameMajorVersion:@4,
                                       SDLRPCParameterNameMinorVersion:@532,
                                       SDLRPCParameterNamePatchVersion:@12} mutableCopy];
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] initWithDictionary:dict];

        expect(testStruct.majorVersion).to(equal(@4));
        expect(testStruct.minorVersion).to(equal(@532));
        expect(testStruct.patchVersion).to(equal(@12));
    });

    it(@"Should return nil if not set", ^ {
        SDLSyncMsgVersion* testStruct = [[SDLSyncMsgVersion alloc] init];

        expect(testStruct.majorVersion).to(beNil());
        expect(testStruct.minorVersion).to(beNil());
        expect(testStruct.patchVersion).to(beNil());
    });
});

QuickSpecEnd
