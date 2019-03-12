//
//  SDLCloudAppProperties.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCloudAppProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLCloudAppProperties

- (instancetype)initWithAppID:(NSString *)appID {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.appID = appID;

    return self;
}

- (instancetype)initWithNicknames:( NSArray<NSString *> *)nicknames appID:(NSString *)appID enabled:(BOOL)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint {
    self = [self initWithAppID:appID];
    if (!self) {
        return nil;
    }

    self.nicknames = nicknames;
    self.enabled = @(enabled);
    self.authToken = authToken;
    self.cloudTransportType = cloudTransportType;
    self.hybridAppPreference = hybridAppPreference;
    self.endpoint = endpoint;

    return self;
}

- (void)setNicknames:(nullable NSArray<NSString *> *)nicknames {
    [store sdl_setObject:nicknames forName:SDLRPCParameterNameNicknames];
}

- (nullable NSArray<NSString *> *)nicknames {
    return [store sdl_objectForName:SDLRPCParameterNameNicknames];
}

- (void)setAppID:(NSString *)appID {
    [store sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    return [store sdl_objectForName:SDLRPCParameterNameAppId];
}

- (void)setEnabled:(nullable NSNumber<SDLBool> *)enabled {
    [store sdl_setObject:enabled forName:SDLRPCParameterNameEnabled];
}

- (nullable NSNumber<SDLBool> *)enabled {
    return [store sdl_objectForName:SDLRPCParameterNameEnabled];
}

- (void)setAuthToken:(nullable NSString *)authToken {
    [store sdl_setObject:authToken forName:SDLRPCParameterNameAuthToken];
}

- (nullable NSString *)authToken {
    return [store sdl_objectForName:SDLRPCParameterNameAuthToken];
}

- (void)setCloudTransportType:(nullable NSString *)cloudTransportType {
    [store sdl_setObject:cloudTransportType forName:SDLRPCParameterNameCloudTransportType];
}

- (nullable NSString *)cloudTransportType {
    return [store sdl_objectForName:SDLRPCParameterNameCloudTransportType];
}

- (void)setHybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference {
    [store sdl_setObject:hybridAppPreference forName:SDLRPCParameterNameHybridAppPreference];
}

- (nullable SDLHybridAppPreference)hybridAppPreference {
    return [store sdl_objectForName:SDLRPCParameterNameHybridAppPreference];
}

- (void)setEndpoint:(nullable NSString *)endpoint {
    [store sdl_setObject:endpoint forName:SDLRPCParameterNameEndpoint];
}

- (nullable NSString *)endpoint {
    return [store sdl_objectForName:SDLRPCParameterNameEndpoint];
}

@end

NS_ASSUME_NONNULL_END
