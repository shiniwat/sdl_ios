#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceCapability.h"
#import "SDLAppServiceManifest.h"
#import "SDLAppServiceRecord.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLHMICapabilities.h"
#import "SDLMediaServiceManifest.h"
#import "SDLNavigationCapability.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLPhoneCapability.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLVideoStreamingCapability.h"
#import "TestConnectionManager.h"


QuickSpecBegin(SDLSystemCapabilityManagerSpec)

describe(@"System capability manager", ^{
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];
    });

    it(@"should initialize the system capability manager properties correctly", ^{
        expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
        expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
        expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
        expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
        expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
        expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
        expect(testSystemCapabilityManager.vrCapability).to(beFalse());
        expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
        expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
        expect(testSystemCapabilityManager.phoneCapability).to(beNil());
        expect(testSystemCapabilityManager.navigationCapability).to(beNil());
        expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
        expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
        expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
    });

    context(@"When notified of a register app interface response", ^{
        __block SDLRegisterAppInterfaceResponse *testRegisterAppInterfaceResponse = nil;
        __block SDLDisplayCapabilities *testDisplayCapabilities = nil;
        __block SDLHMICapabilities *testHMICapabilities = nil;
        __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities = nil;
        __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities = nil;
        __block SDLPresetBankCapabilities *testPresetBankCapabilities = nil;
        __block NSArray<SDLHMIZoneCapabilities> *testHMIZoneCapabilities = nil;
        __block NSArray<SDLSpeechCapabilities> *testSpeechCapabilities = nil;
        __block NSArray<SDLPrerecordedSpeech> *testPrerecordedSpeechCapabilities = nil;
        __block NSArray<SDLVRCapabilities> *testVRCapabilities = nil;
        __block NSArray<SDLAudioPassThruCapabilities *> *testAudioPassThruCapabilities = nil;
        __block SDLAudioPassThruCapabilities *testPCMStreamCapability = nil;

        beforeEach(^{
            testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
            testDisplayCapabilities.graphicSupported = @NO;

            testHMICapabilities = [[SDLHMICapabilities alloc] init];
            testHMICapabilities.navigation = @NO;
            testHMICapabilities.phoneCall = @YES;
            testHMICapabilities.videoStreaming = @YES;

            SDLSoftButtonCapabilities *softButtonCapability = [[SDLSoftButtonCapabilities alloc] init];
            softButtonCapability.shortPressAvailable = @YES;
            softButtonCapability.longPressAvailable = @NO;
            softButtonCapability.upDownAvailable = @NO;
            softButtonCapability.imageSupported = @YES;
            testSoftButtonCapabilities = @[softButtonCapability];

            SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
            buttonCapabilities.name = SDLButtonNameOk;
            buttonCapabilities.shortPressAvailable = @YES;
            buttonCapabilities.longPressAvailable = @YES;
            buttonCapabilities.upDownAvailable = @YES;
            testButtonCapabilities = @[buttonCapabilities];

            testPresetBankCapabilities = [[SDLPresetBankCapabilities alloc] init];
            testPresetBankCapabilities.onScreenPresetsAvailable = @NO;

            testHMIZoneCapabilities = @[SDLHMIZoneCapabilitiesFront, SDLHMIZoneCapabilitiesBack];
            testSpeechCapabilities = @[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesSilence];
            testPrerecordedSpeechCapabilities = @[SDLPrerecordedSpeechHelp, SDLPrerecordedSpeechInitial];
            testVRCapabilities = @[SDLVRCapabilitiesText];

            SDLAudioPassThruCapabilities *audioPassThruCapability = [[SDLAudioPassThruCapabilities alloc] init];
            audioPassThruCapability.samplingRate = SDLSamplingRate8KHZ;
            audioPassThruCapability.bitsPerSample = SDLBitsPerSample8Bit;
            audioPassThruCapability.audioType = SDLAudioTypePCM;
            testAudioPassThruCapabilities = @[audioPassThruCapability];
            testPCMStreamCapability = audioPassThruCapability;

            testRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
            testRegisterAppInterfaceResponse.displayCapabilities = testDisplayCapabilities;
            testRegisterAppInterfaceResponse.hmiCapabilities = testHMICapabilities;
            testRegisterAppInterfaceResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testRegisterAppInterfaceResponse.buttonCapabilities = testButtonCapabilities;
            testRegisterAppInterfaceResponse.presetBankCapabilities = testPresetBankCapabilities;
            testRegisterAppInterfaceResponse.hmiZoneCapabilities = testHMIZoneCapabilities;
            testRegisterAppInterfaceResponse.speechCapabilities = testSpeechCapabilities;
            testRegisterAppInterfaceResponse.prerecordedSpeech = testPrerecordedSpeechCapabilities;
            testRegisterAppInterfaceResponse.vrCapabilities = testVRCapabilities;
            testRegisterAppInterfaceResponse.audioPassThruCapabilities = testAudioPassThruCapabilities;
            testRegisterAppInterfaceResponse.pcmStreamCapabilities = testPCMStreamCapability;
        });

        describe(@"If the Register App Interface request fails", ^{
            beforeEach(^{
                testRegisterAppInterfaceResponse.success = @NO;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not save any of the RAIR capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
                expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.vrCapability).to(beFalse());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
                expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            });
        });

        describe(@"If the Register App Interface request succeeds", ^{
            beforeEach(^{
                testRegisterAppInterfaceResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the RAIR capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.hmiCapabilities).to(equal(testHMICapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(equal(testHMIZoneCapabilities));
                expect(testSystemCapabilityManager.speechCapabilities).to(equal(testSpeechCapabilities));
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(equal(testPrerecordedSpeechCapabilities));
                expect(testSystemCapabilityManager.vrCapability).to(beTrue());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(equal(testAudioPassThruCapabilities));
                expect(testSystemCapabilityManager.pcmStreamCapability).to(equal(testPCMStreamCapability));
            });
        });

        afterEach(^{
            // Make sure the system capabilities properties were not inadverdently set
            expect(testSystemCapabilityManager.phoneCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        });
    });

    context(@"When notified of a Set Display Layout Response", ^ {
        __block SDLSetDisplayLayoutResponse *testSetDisplayLayoutResponse = nil;
        __block SDLDisplayCapabilities *testDisplayCapabilities = nil;
        __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities = nil;
        __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities = nil;
        __block SDLPresetBankCapabilities *testPresetBankCapabilities = nil;

        beforeEach(^{
            testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
            testDisplayCapabilities.graphicSupported = @NO;

            SDLSoftButtonCapabilities *softButtonCapability = [[SDLSoftButtonCapabilities alloc] init];
            softButtonCapability.shortPressAvailable = @NO;
            softButtonCapability.longPressAvailable = @NO;
            softButtonCapability.upDownAvailable = @NO;
            softButtonCapability.imageSupported = @NO;
            testSoftButtonCapabilities = @[softButtonCapability];

            SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
            buttonCapabilities.name = SDLButtonNameOk;
            buttonCapabilities.shortPressAvailable = @NO;
            buttonCapabilities.longPressAvailable = @NO;
            buttonCapabilities.upDownAvailable = @NO;
            testButtonCapabilities = @[buttonCapabilities];

            testPresetBankCapabilities = [[SDLPresetBankCapabilities alloc] init];
            testPresetBankCapabilities.onScreenPresetsAvailable = @NO;

            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
            testSetDisplayLayoutResponse.displayCapabilities = testDisplayCapabilities;
            testSetDisplayLayoutResponse.buttonCapabilities = testButtonCapabilities;
            testSetDisplayLayoutResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testSetDisplayLayoutResponse.presetBankCapabilities = testPresetBankCapabilities;
        });

        describe(@"If the Set Display Layout request fails", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @NO;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not save any capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
            });
        });

        describe(@"If the Set Display Layout request succeeds", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
            });
        });

        afterEach(^{
            // Make sure the other RAIR properties and system capabilities were not inadverdently set
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.phoneCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        });
    });

    context(@"When sending a Get System Capability request", ^{
        __block SDLGetSystemCapabilityResponse *testGetSystemCapabilityResponse;
        __block SDLPhoneCapability *testPhoneCapability = nil;

        beforeEach(^{
            testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

            testGetSystemCapabilityResponse = [[SDLGetSystemCapabilityResponse alloc] init];
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.phoneCapability = testPhoneCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
        });

        context(@"If the request failed with an error", ^{
            __block NSError *testError = nil;

            beforeEach(^{
                testGetSystemCapabilityResponse.success = @NO;
                testError = [NSError errorWithDomain:NSCocoaErrorDomain code:-234 userInfo:nil];
            });

            it(@"should should not save the capabilities", ^{
                waitUntilTimeout(1, ^(void (^done)(void)) {
                    [testSystemCapabilityManager updateCapabilityType:testGetSystemCapabilityResponse.systemCapability.systemCapabilityType completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                        expect(error).to(equal(testConnectionManager.defaultError));
                        expect(systemCapabilityManager.phoneCapability).to(beNil());
                        done();
                    }];

                    [NSThread sleepForTimeInterval:0.1];

                    [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse];
                });
            });
        });

        context(@"If the request succeeded", ^{
            beforeEach(^{
                testGetSystemCapabilityResponse.success = @YES;
            });

            it(@"should save the capabilitity", ^{
                waitUntilTimeout(1, ^(void (^done)(void)){
                    [testSystemCapabilityManager updateCapabilityType:testGetSystemCapabilityResponse.systemCapability.systemCapabilityType completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                        expect(testSystemCapabilityManager.phoneCapability).to(equal(testPhoneCapability));
                        expect(error).to(beNil());
                        done();
                    }];

                    [NSThread sleepForTimeInterval:0.1];

                    [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse];
                });
            });
        });

        afterEach(^{
            // Make sure the RAIR properties and other system capabilities were not inadverdently set
            expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
            expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        });
    });

    describe(@"updating the SCM through OnSystemCapability", ^{
        __block SDLPhoneCapability *phoneCapability = nil;

        beforeEach(^{
            phoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
            SDLSystemCapability *newCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:phoneCapability];
            SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:newCapability];
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should properly update phone capability", ^{
            expect(testSystemCapabilityManager.phoneCapability).toEventually(equal(phoneCapability));
        });
    });

    describe(@"merging app services capability changes", ^{
        __block SDLAppServicesCapabilities *baseAppServices = nil;
        __block SDLAppServiceCapability *deleteCapability = nil;
        __block SDLAppServiceCapability *updateCapability = nil;
        __block SDLAppServiceCapability *newCapability = nil;

        beforeEach(^{
            SDLAppServiceManifest *deleteCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"Delete me" serviceIcon:nil allowAppConsumers:YES rpcSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
            SDLAppServiceRecord *deleteCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"1234" serviceManifest:deleteCapabilityManifest servicePublished:YES serviceActive:YES];
            deleteCapability = [[SDLAppServiceCapability alloc] initWithUpdatedAppServiceRecord:deleteCapabilityRecord];

            SDLAppServiceManifest *updateCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"Update me" serviceIcon:nil allowAppConsumers:YES rpcSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
            SDLAppServiceRecord *updateCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"2345" serviceManifest:updateCapabilityManifest servicePublished:YES serviceActive:NO];
            updateCapability = [[SDLAppServiceCapability alloc] initWithUpdatedAppServiceRecord:updateCapabilityRecord];

            baseAppServices = [[SDLAppServicesCapabilities alloc] initWithAppServices:@[deleteCapability, updateCapability]];
            SDLSystemCapability *appServiceCapability = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:baseAppServices];
            SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:appServiceCapability];
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should have the correct base services", ^{
            expect(testSystemCapabilityManager.appServicesCapabilities).to(equal(baseAppServices));
        });

        describe(@"when sending the merge update", ^{
            it(@"should correctly merge", ^{
                deleteCapability.updateReason = SDLServiceUpdateRemoved;
                deleteCapability.updatedAppServiceRecord.servicePublished = @NO;
                deleteCapability.updatedAppServiceRecord.serviceActive = @NO;

                updateCapability.updateReason = SDLServiceUpdateActivated;
                updateCapability.updatedAppServiceRecord.serviceActive = @YES;

                SDLAppServiceManifest *newCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"New me" serviceIcon:nil allowAppConsumers:YES rpcSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
                SDLAppServiceRecord *newCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"3456" serviceManifest:newCapabilityManifest servicePublished:YES serviceActive:NO];
                newCapability = [[SDLAppServiceCapability alloc] initWithUpdateReason:SDLServiceUpdatePublished updatedAppServiceRecord:newCapabilityRecord];

                SDLAppServicesCapabilities *appServicesUpdate = [[SDLAppServicesCapabilities alloc] initWithAppServices:@[deleteCapability, updateCapability, newCapability]];
                SDLSystemCapability *appServiceCapability = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:appServicesUpdate];
                SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:appServiceCapability];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                expect(testSystemCapabilityManager.appServicesCapabilities.appServices).toNot(contain(deleteCapability));
                expect(testSystemCapabilityManager.appServicesCapabilities.appServices).to(haveCount(2));

                SDLAppServiceCapability *firstCapability = testSystemCapabilityManager.appServicesCapabilities.appServices.firstObject;
                SDLAppServiceCapability *secondCapability = testSystemCapabilityManager.appServicesCapabilities.appServices.lastObject;

                expect(firstCapability.updateReason).to(equal(SDLServiceUpdatePublished));
                expect(firstCapability.updatedAppServiceRecord.serviceID).to(equal(@"3456"));

                expect(secondCapability.updateReason).to(equal(SDLServiceUpdateActivated));
                expect(secondCapability.updatedAppServiceRecord.serviceID).to(equal(@"2345"));
                expect(secondCapability.updatedAppServiceRecord.serviceActive).to(beTrue());
            });
        });
    });

    describe(@"when entering HMI FULL", ^{
        beforeEach(^{
            SDLOnHMIStatus *fullStatus = [[SDLOnHMIStatus alloc] init];
            fullStatus.hmiLevel = SDLHMILevelFull;
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:fullStatus];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should send GetSystemCapability subscriptions for all known capabilities", ^{
            expect(testConnectionManager.receivedRequests).to(haveCount(5));
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLGetSystemCapability class]));
        });
    });

    describe(@"when the system capability manager is stopped after being started", ^{
        beforeEach(^{
            [testSystemCapabilityManager stop];
        });

        it(@"It should reset the system capability manager properties correctly", ^{
            expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
            expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.phoneCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        });
    });
});

QuickSpecEnd

